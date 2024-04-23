extends Node

# Audio
var audio_master: float = 1.0
var audio_sfx: float = 1.0
var audio_music: float = 1.0

func _ready() -> void:
	InputMap.load_from_project_settings()


func get_value(prop_name: String) -> float:
	match prop_name:
		"Master":
			return audio_master
		"Sfx":
			return audio_sfx
		"Music":
			return audio_music
	return 0.0


func set_value(prop_name: String, value: float) -> void:
	match prop_name:
		"Master":
			audio_master = value
		"Sfx":
			audio_sfx = value
		"Music":
			audio_music = value
