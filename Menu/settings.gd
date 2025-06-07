extends Control

@onready var master_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/SFXSlider
@onready var music_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MusicSlider

@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")
@onready var video_mode_option: OptionButton = $AudioOptions/PanelContainer2/VBoxContainer/VideoModeOption
@onready var mute_check: CheckButton = $MuteButton
@onready var vsync_check: CheckButton = $VsyncButton

signal closed

func _ready() -> void:
	var audio_settings = ConfigFileHandler.load_audio_settings()
	print(linear_to_db(audio_settings.music_volume))
	master_slider.value = min(audio_settings.master_volume, 1.0) * 100
	sfx_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	music_slider.value = min(audio_settings.music_volume, 1.0) * 100
	
	var muted_on = ConfigFileHandler.load_muted()
	mute_check.button_pressed = muted_on
	
	var saved_mode := ConfigFileHandler.load_window_mode()
	
	var vsync_on = ConfigFileHandler.load_vsync()
	_apply_vsync(vsync_on)
	vsync_check.button_pressed = vsync_on	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		AudioPlayer.play_FX(back_button, -10)
		accept_event()
		emit_signal("closed")
		GlobalCount.in_subtree_menu = false
		queue_free()

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_slider.value / 100)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", master_slider.value / 100)

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_slider.value / 100)

func _on_back_pressed() -> void:
	GlobalCount.in_subtree_menu = false
	AudioPlayer.play_FX(back_button, -10)
	emit_signal("closed")
	queue_free()


func _on_item_list_item_selected(index: int) -> void:
	var mode: String
	match index:
		0: mode = "exclusive_fullscreen"
		1: mode = "windowed"
		_: return
		
	ConfigFileHandler.apply_window_mode(mode)
	ConfigFileHandler.save_window_mode(mode)
	
func _apply_vsync(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
	AudioServer.set_bus_mute(1, toggled_on)
	AudioServer.set_bus_mute(2, toggled_on)
	ConfigFileHandler.save_audio_setting("muted", toggled_on)


func _on_vsync_button_toggled(toggled_on: bool) -> void:
	_apply_vsync(toggled_on)
	ConfigFileHandler.save_vsync(toggled_on)
