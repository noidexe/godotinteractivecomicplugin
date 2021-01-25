extends IC_Input


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_right"):
		emit_signal("next_selected")
	elif event.is_action_pressed("ui_left"):
		emit_signal("previous_selected")
