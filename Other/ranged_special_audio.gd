extends Node2D
@onready var laser_line_audio: AudioStreamPlayer2D = $LaserLineAudio

func _ready():
	laser_line_audio.play()


func _on_laser_line_audio_finished() -> void:
	queue_free()
