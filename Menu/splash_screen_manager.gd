extends Control

@export var load_scene : PackedScene = preload("res://Levels/MainMenu.tscn")
@export var fade_out_time : float = 4.18 #2.09
@export var pause_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_screen : TextureRect
@onready var godot_logo: TextureRect = $CenterContainer/GodotLogo
@onready var vifer_logo: TextureRect = $CenterContainer/ViferLogo
@onready var menu_music: AudioStreamPlayer2D = $MainMenuMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var saved_mode := ConfigFileHandler.load_window_mode()
	ConfigFileHandler.apply_window_mode(saved_mode)
	vifer_logo.visible = false
	vifer_logo.modulate.a = 1.0
	godot_logo.visible = false
	await get_tree().create_timer(1).timeout
	fade()

func fade() -> void:
	vifer_logo.visible = true
	AudioPlayer.play_music(menu_music.stream, -30)
	var tween_vifer = self.create_tween()
	tween_vifer.tween_property(vifer_logo, "modulate:a", 0.0, fade_out_time)
	await get_tree().create_timer(fade_out_time).timeout
	godot_logo.visible = true
	var tween_godot = self.create_tween()
	tween_godot.tween_property(godot_logo, "modulate:a", 0.0, fade_out_time)
	await get_tree().create_timer(fade_out_time).timeout
	TransitionScreen.transition_main_menu()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(load_scene)
	
