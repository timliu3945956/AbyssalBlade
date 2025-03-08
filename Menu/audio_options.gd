extends Control

@onready var master_slider: HSlider = $PanelContainer2/VBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $PanelContainer2/VBoxContainer/SFXSlider
@onready var music_slider: HSlider = $PanelContainer2/VBoxContainer/MusicSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))



func _on_master_slider_mouse_exited() -> void:
	release_focus()
	
func _on_sfx_slider_mouse_exited() -> void:
	release_focus()

func _on_music_slider_mouse_exited() -> void:
	release_focus()
