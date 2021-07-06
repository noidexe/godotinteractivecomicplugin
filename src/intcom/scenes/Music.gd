extends Node
class_name IC_Music

export var music_track : AudioStream = null setget set_music_track, get_music_track

func set_music_track(track : AudioStream):
	if !self.is_inside_tree():
		return
	music_track = track
	AudioPlayer.play_music(music_track)
	
func get_music_track() -> AudioStream:
	return music_track
