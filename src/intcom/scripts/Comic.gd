extends IC_Sequencer

onready var transitions = $transitions
var is_transitioning = false

export(NodePath) var subtransition_target = NodePath()

func _ready():
	transitions.connect("frame_reached", self, "_on_frame_reached")
	transitions.connect("transition_started", self, "_on_transition_started")
	transitions.connect("transition_finished", self, "_on_transition_finished")

func show_next():
	.show_next()
	subtransition_target = transitions.subtransitions.get(current, NodePath())
	if is_transitioning:
		subtransition_target = NodePath()
	if subtransition_target and get_node(subtransition_target).transitions.at_end:
		subtransition_target = NodePath()
	if not subtransition_target.is_empty() and not get_node(subtransition_target).transitions.at_end:
		get_node(subtransition_target).show_next()
	else:
		transitions.next()

	
func show_previous():
	.show_previous()
	subtransition_target = transitions.subtransitions.get(current, NodePath())
	if is_transitioning:
		subtransition_target = NodePath()
	if subtransition_target and get_node(subtransition_target).transitions.at_start:
		subtransition_target = NodePath()
	if not subtransition_target.is_empty() and not get_node(subtransition_target).transitions.at_start:
		get_node(subtransition_target).show_previous()
	else:
		transitions.back()


func _on_transition_started():
	is_transitioning = true
	emit_signal("transition_started")

func _on_transition_finished():
	is_transitioning = false
	emit_signal("transition_ended")

func register_input(input_handler:IC_Input):
	if input_handler.connect("next_selected", self, "show_next") != OK:
		push_error("Error conecting next_selected")
	if input_handler.connect("previous_selected", self, "show_previous") != OK:
		push_error("Error conecting previous_selected")
	if input_handler.connect("parallax_motion", self, "update_parallax") != OK:
		push_error("Error conecting parallax_motion")

func update_parallax(_motion:Vector2):
	push_warning("Parallax motion unimplemented")


func _on_frame_reached(cur, _prev):
	current = cur

