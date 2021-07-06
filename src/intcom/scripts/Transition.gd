extends AnimationPlayer


export var frame := 0
export var target_frame := 0
var forward = true
var is_transitioning = false
export var transition_length := 0.4

var at_start = true
var at_end = false

signal transition_started()
signal transition_finished()
signal frame_reached(cur, prev)

var subtransitions = Dictionary()

# Called when the node enters the scene tree for the first time.
func _ready():
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	play("transitions")
	_fix_backwards_transition_length()
	_fix_backwards_music_track()
	_fix_sfx_track()
	subtransitions = _get_subtransitions()
	print(subtransitions)
	pass # Replace with function body.

func _process(delta):
	var prev_frame = frame
	# Calculate speedup
	# If we are within the same frame it advances at normal speed
	# If we are more than one frame ahead/behind, it advances by the square of that
	var speedup = ceil(abs(current_animation_position - target_frame))
	delta *= speedup * speedup

	if forward:
		advance(delta)
		if current_animation_position > target_frame:
			seek(target_frame, true)
# warning-ignore:narrowing_conversion
		frame = floor(current_animation_position)
	else:
		advance(-delta)
		if current_animation_position < target_frame:
			seek(target_frame, true)
# warning-ignore:narrowing_conversion
		frame = ceil(current_animation_position)
	if frame != prev_frame:
		emit_signal("frame_reached", frame, prev_frame)
	_update_is_transitioning()
	playback_speed = 1.0 / transition_length

func next():
# warning-ignore:narrowing_conversion
	#target_frame = min(target_frame+1, int(current_animation_length))
	if forward and is_transitioning:
		seek(target_frame, true)
		return
	target_frame += 1
	if target_frame > int(current_animation_length):
		target_frame = int(current_animation_length)
		seek(target_frame, true)
		at_start = false
		at_end = true
	forward = true
	
func back():
# warning-ignore:narrowing_conversion
	#target_frame = max(target_frame-1,0)
	if not forward and is_transitioning:
		seek(target_frame, true)
		return
	target_frame -= 1
	if target_frame < 0:
		target_frame = 0
		seek(target_frame, true)
		at_start = true
		at_end = false
	forward = false

func _update_is_transitioning():
	if is_transitioning and frame == target_frame:
		is_transitioning = false
		emit_signal("transition_finished")
		at_start = frame == 0
		at_end = frame == int(current_animation_length)
	if not is_transitioning and frame != target_frame:
		is_transitioning = true
		at_start = false
		at_end = false
		emit_signal("transition_started")
	
func _fix_backwards_transition_length():
	var anim : Animation = get_animation("transitions")
	var track = anim.find_track("transitions:transition_length")
	if track == -1:
		return
	anim.value_track_set_update_mode(track,Animation.UPDATE_CONTINUOUS)
	anim.track_set_interpolation_type(track,Animation.INTERPOLATION_NEAREST)
	var key_count = anim.track_get_key_count(track)
	var backwards_keys = []
	for i in range(1,key_count):
		var time = anim.track_get_key_time(track, i) - 0.01
		var value = anim.track_get_key_value(track, i-1)
		backwards_keys.append([time,value])
	for key in backwards_keys:
		anim.track_insert_key(track,key[0],key[1])
	
func _fix_backwards_music_track():
	var anim : Animation = get_animation("transitions")
	var track = anim.find_track("Music:music_track")
	if track == -1:
		return
	anim.value_track_set_update_mode(track,Animation.UPDATE_DISCRETE)
	anim.track_set_interpolation_type(track,Animation.INTERPOLATION_NEAREST)
	var key_count = anim.track_get_key_count(track)
	var backwards_keys = []
	for i in range(1,key_count):
		var time = anim.track_get_key_time(track, i) - 0.1
		var value = anim.track_get_key_value(track, i-1)
		backwards_keys.append([time,value])
	for key in backwards_keys:
		anim.track_insert_key(track,key[0],key[1])

func _fix_sfx_track():
	var anim : Animation = get_animation("transitions")
	var track = anim.find_track("SoundEffects:sfx")
	if track == -1:
		return
	anim.value_track_set_update_mode(track,Animation.UPDATE_TRIGGER)

func _get_subtransitions() -> Dictionary:
	var ret = Dictionary()
	var anim : Animation = get_animation("transitions")
	var track = anim.find_track(".:subtransition_target")
	if track == -1:
		return ret
	anim.value_track_set_update_mode(track,Animation.UPDATE_DISCRETE)
	var key_count = anim.track_get_key_count(track)
	for i in key_count:
		var time = int(anim.track_get_key_time(track, i))
		var value = anim.track_get_key_value(track, i)
		ret[time] = value
	anim.track_set_enabled(track, false)
	return ret
