extends Node2D
class_name IC_Sequencer

var current:int = 0

# warning-ignore:unused_signal
signal transition_started(id)
# warning-ignore:unused_signal
signal transition_ended(id)

func show_next() -> void:
	current +=1

	
func show_previous() -> void:
	current -=1

