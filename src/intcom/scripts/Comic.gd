extends IC_Sequencer

onready var transitions = $transitions
var is_transitioning = false

export(NodePath) var subtransition_target = NodePath()

func show_next():
	.show_next()
	if subtransition_target and get_node(subtransition_target).transitions.at_end:
		subtransition_target = NodePath()
	if not subtransition_target.is_empty() and not get_node(subtransition_target).transitions.at_end:
		get_node(subtransition_target).show_next()
	else:
		transitions.next()
	print(subtransition_target)

	
func show_previous():
	.show_previous()
	if subtransition_target and get_node(subtransition_target).transitions.at_start:
		subtransition_target = NodePath()
	if not subtransition_target.is_empty() and not get_node(subtransition_target).transitions.at_start:
		get_node(subtransition_target).show_previous()
	else:
		transitions.back()
	print(subtransition_target)


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


func _on_transitions_frame_reached(cur, prev):
	print(transitions.subtransitions.get(cur, NodePath()))
	subtransition_target = transitions.subtransitions.get(cur, NodePath())
