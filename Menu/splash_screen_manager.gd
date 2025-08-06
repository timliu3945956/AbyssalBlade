extends Control

@export var load_scene : PackedScene = preload("res://Levels/MainMenu.tscn")
@export var fade_out_time : float = 4.18 #2.09
@export var pause_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_screen : TextureRect
@onready var godot_logo: TextureRect = $CenterContainer/GodotLogo
@onready var vifer_logo: TextureRect = $CenterContainer/ViferLogo
@onready var vifer_logo_video: VideoStreamPlayer = $ViferLogoVideo

@onready var menu_music: AudioStreamPlayer2D = $MainMenuMusic

#func _apply_bus_volume(bus_name: String, linear: float) -> void:
	#var idx := AudioServer.get_bus_index(bus_name)
	#AudioServer.set_bus_volume_db(idx, linear_to_db(clamp(linear, 0.0, 1.0)))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var saved_mode := ConfigFileHandler.load_window_mode()
	ConfigFileHandler.apply_window_mode(saved_mode)
	ConfigFileHandler.apply_saved_audio()
	#var audio = ConfigFileHandler.load_audio_settings()
	#if audio_settings.master_volume == 0.1:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume * 10))
	#else:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume * 100))
		#
	#if audio_settings.sfx_volume == 0.1:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_settings.sfx_volume * 10))
	#else:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_settings.sfx_volume * 100))
	#
	#if audio_settings.music_volume == 0.1:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume * 10))
	#else:
		#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume * 100))
	#_apply_bus_volume("Master", audio["master_volume"])
	#_apply_bus_volume("SFX", audio["sfx_volume"])
	#_apply_bus_volume("Music", audio["music_volume"])
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), audio["muted"])
	vifer_logo.visible = false
	vifer_logo.modulate.a = 1.0
	godot_logo.visible = false
	await get_tree().create_timer(1).timeout
	fade()

func fade() -> void:
	vifer_logo_video.play()
	#vifer_logo.visible = true
	#AudioPlayer.play_music(menu_music.stream, -30)
	#var tween_vifer = self.create_tween()
	#tween_vifer.tween_property(vifer_logo, "modulate:a", 0.0, fade_out_time)
	await get_tree().create_timer(fade_out_time).timeout
	#godot_logo.visible = true
	#var tween_godot = self.create_tween()
	#tween_godot.tween_property(godot_logo, "modulate:a", 0.0, fade_out_time)
	#await get_tree().create_timer(fade_out_time).timeout
	TransitionScreen.transition_main_menu()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(load_scene)
	
