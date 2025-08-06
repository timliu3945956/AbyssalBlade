extends Control

@onready var master_slider: HSlider = $GridContainer/MasterSlider
@onready var sfx_slider: HSlider = $GridContainer/SFXSlider
@onready var music_slider: HSlider = $GridContainer/MusicSlider

func _on_master_slider_mouse_exited() -> void:
	release_focus()
	
func _on_sfx_slider_mouse_exited() -> void:
	release_focus()

func _on_music_slider_mouse_exited() -> void:
	release_focus()
