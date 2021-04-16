extends IC_Input



func _on_prev_pressed():
	emit_signal("previous_selected")


func _on_next_pressed():
	emit_signal("next_selected")
