extends AnimationPlayer


export var frame := 0
export var target_frame := 0
var forward = true
var is_transitioning = false
export var transition_length := 0.4

signal transition_started()
signal transition_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	pass # Replace with function body.

func _process(delta):
	# Calculate speedup
	# If we are within the same frame it advances at normal speed
	# If we are more than one frame ahead/behind, it advances by the square of that
	var speedup = ceil(abs(current_animation_position - target_frame))
	delta *= speedup * speedup

	if forward:
		advance(delta)
		if current_animation_position > target_frame:
			seek(target_frame, true)
		frame = floor(current_animation_position)
	else:
		advance(-delta)
		if current_animation_position < target_frame:
			seek(target_frame, true)
		frame = ceil(current_animation_position)
	_update_is_transitioning()
	playback_speed = 1.0 / transition_length

func next():
	forward = true
	target_frame = min(target_frame+1, int(current_animation_length))
	pass
	
func back():
	forward = false
	target_frame = max(target_frame-1,0)
	pass

func _update_is_transitioning():
	if is_transitioning and frame == target_frame:
		is_transitioning = false
		emit_signal("transition_finished")
	if not is_transitioning and frame != target_frame:
		is_transitioning = true
		emit_signal("transition_started")
	
func _fix_backward_transition_lenght():
	var anim : Animation = get_animation("transitions")
	var track = anim.find_track("transitions:transition_length")
	var key_count = anim.track_get_key_count(track)
	var backwards_keys = []
	for i in range(1,key_count):
		var time = anim.track_get_key_time(track, i) - 0.01
		var value = anim.track_get_key_value(track, i-1)
		backwards_keys.append([time,value])
	for key in backwards_keys:
		anim.track_insert_key(track,key[0],key[1])
