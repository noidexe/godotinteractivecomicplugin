extends Node
class_name IC_Input

# warning-ignore:unused_signal
signal next_selected()
# warning-ignore:unused_signal
signal previous_selected()
# warning-ignore:unused_signal
signal parallax_motion(motion)

func _ready():
	owner.register_input(self)
