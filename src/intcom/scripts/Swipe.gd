extends IC_Input

# TODO: Clean up, make configurable

var touch_start = null

func _input(event):
	if not ( 
		event is InputEventMouseButton and
		event.button_index == BUTTON_LEFT
		):
		return
	if event.pressed:
		touch_start = {
			"pos" : get_viewport().get_mouse_position(),
			"timestamp" : OS.get_ticks_msec()
		}
	else:
		if not touch_start:
			return
		var total_time = OS.get_ticks_msec() - touch_start.timestamp
		var horizontal_distance = get_viewport().get_mouse_position().x - touch_start.pos.x
		if total_time > 2000 or abs(horizontal_distance) < 100:
			return
		if horizontal_distance < 0:
			emit_signal("next_selected")
		else:
			emit_signal("previous_selected")
