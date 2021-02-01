extends IC_Sequencer

onready var transitions = $transitions
var is_transitioning = false

func show_next():
	#if is_transitioning:
	#	return
	.show_next()
	transitions.next()
	#transitions.play(str(current))
	
func show_previous():
	#if is_transitioning:
	#	return
	#transitions.play_backwards(str(current))
	transitions.back()
	.show_previous()
	

func _on_transitions_animation_started(anim_name):
	is_transitioning = true
	emit_signal("transition_started", anim_name)

func _on_transitions_animation_finished(anim_name):
	is_transitioning = false
	emit_signal("transition_ended", anim_name)

func register_input(input_handler:IC_Input):
	if input_handler.connect("next_selected", self, "show_next") != OK:
		push_error("Error conecting next_selected")
	if input_handler.connect("previous_selected", self, "show_previous") != OK:
		push_error("Error conecting previous_selected")
	if input_handler.connect("parallax_motion", self, "update_parallax") != OK:
		push_error("Error conecting parallax_motion")

func update_parallax(_motion:Vector2):
	push_warning("Parallax motion unimplemented")
