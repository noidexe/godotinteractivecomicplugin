extends IC_Input

var _prev_action_name = "ui_left"
var _next_action_name = "ui_right"

func _ready():
	if InputMap.has_action("comic_prev"):
		_prev_action_name = "comic_prev"
	if InputMap.has_action("comic_next"):
		_next_action_name = "comic_next"

func _unhandled_key_input(event):
	if event.is_action_pressed(_next_action_name):
		emit_signal("next_selected")
	elif event.is_action_pressed(_prev_action_name):
		emit_signal("previous_selected")
