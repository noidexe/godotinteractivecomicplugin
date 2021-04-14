extends IC_Input

var available = true
export(float,0, 1, 0.05) var response_interval_seconds = 0.1

const idx2event =  {
	BUTTON_WHEEL_DOWN : "next_selected",
	BUTTON_WHEEL_UP : "previous_selected"
}

func _input(event):
	#Checks
	if (
		available and
		event is InputEventMouseButton and
		event.pressed and
		event.button_index in [BUTTON_WHEEL_DOWN, BUTTON_WHEEL_UP]
	):
		_emit_event(event.button_index)

func _emit_event(idx):	
	emit_signal(idx2event[idx])
	available = false
	yield(get_tree().create_timer(response_interval_seconds),"timeout")
	available = true
