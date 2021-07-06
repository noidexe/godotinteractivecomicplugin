extends Node
class_name IC_SoundEffects

export var sfx : AudioStream = null setget set_sfx, get_sfx

func set_sfx(stream : AudioStream):
	if !self.is_inside_tree():
		return
	sfx = stream
	AudioPlayer.play_sfx(sfx)
	
func get_sfx() -> AudioStream:
	return sfx
