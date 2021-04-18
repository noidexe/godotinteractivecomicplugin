extends IC_Input

var touch_start = null
var pixels_per_cm = OS.get_screen_dpi() / 2.54
export(float, 1, 10, 0.5) var swipe_min_distance_cm = 1.5
export(int, 0, 5000, 10) var swipe_max_time_ms = 2000
var _swipe_min_distance_px = swipe_min_distance_cm / pixels_per_cm

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
		if total_time > swipe_max_time_ms or abs(horizontal_distance) < _swipe_min_distance_px:
			return
		if horizontal_distance < 0:
			emit_signal("next_selected")
		else:
			emit_signal("previous_selected")
