extends Node2D
class_name IC_Sequencer

enum { BACKWARDS, FORWARD }

var current:int = 0
var is_transitioning = false

onready var transitions = $transitions

export(NodePath) var subtransition_target = NodePath()

# warning-ignore:unused_signal
signal transition_started(id)
# warning-ignore:unused_signal
signal transition_ended(id)

func _ready():
	transitions.connect("frame_reached", self, "_on_frame_reached")
	transitions.connect("transition_started", self, "_on_transition_started")
	transitions.connect("transition_finished", self, "_on_transition_finished")

func show_next():
	subtransition_target = _get_subtransition_target(FORWARD)
	if not subtransition_target.is_empty() and not get_node(subtransition_target).transitions.at_end:
		get_node(subtransition_target).show_next()
	else:
		transitions.next()

	
func show_previous():
	subtransition_target = _get_subtransition_target(BACKWARDS)
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

func _get_subtransition_target(direction:int) -> NodePath:
	if is_transitioning:
		return NodePath()
	var new_target = transitions.subtransitions.get(current, NodePath())
	if not new_target:
		return NodePath()
	if direction == FORWARD and get_node(new_target).transitions.at_end:
		return NodePath()
	if direction == BACKWARDS and get_node(new_target).transitions.at_start:
		return NodePath()
	return new_target
	
