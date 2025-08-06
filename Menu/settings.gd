extends Control

@onready var master_slider: HSlider = $AudioOptions/GridContainer/MasterSlider
@onready var sfx_slider: HSlider = $AudioOptions/GridContainer/SFXSlider
@onready var music_slider: HSlider = $AudioOptions/GridContainer/MusicSlider

@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")

@onready var window_check: CheckBox = $AudioOptions/GridContainer/Control/WindowCheck
@onready var fullscreen_check: CheckBox = $AudioOptions/GridContainer/Control/FullscreenCheck

#@onready var mute_check: CheckButton = $MuteButton
#@onready var vsync_check: CheckButton = $VsyncButton

@onready var mute_check: CheckBox = $AudioOptions/GridContainer/Control3/MuteButton
@onready var vsync_check: CheckBox = $AudioOptions/GridContainer/Control2/VsyncButton

@onready var input_mgr = InputManager
signal closed

func _ready() -> void:
	input_mgr.InputSourceChanged.connect(_on_input_source_changed)
	_apply_focus(input_mgr.activeInputSource)
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	print(linear_to_db(audio_settings.music_volume))
	master_slider.value = audio_settings.master_volume * 100
	sfx_slider.value = audio_settings.sfx_volume * 100
	music_slider.value = audio_settings.music_volume * 100
	mute_check.button_pressed = audio_settings.muted
	
	var muted_on = ConfigFileHandler.load_muted()
	mute_check.button_pressed = muted_on
	
	var saved_mode := ConfigFileHandler.load_window_mode()
	if saved_mode == "" or saved_mode == null:
		saved_mode = "exclusive_fullscreen"
	_set_window_mode(saved_mode)
	
	var vsync_on = ConfigFileHandler.load_vsync()
	_apply_vsync(vsync_on)
	vsync_check.button_pressed = vsync_on	
	
func _on_input_source_changed(source: int) -> void:
	_apply_focus(source)
	
func _apply_focus(source: int) -> void:
	if source == InputManager.InputSource.CONTROLLER:
		window_check.grab_focus()
	else:
		_clear_focus()
		
func _clear_focus() -> void:
	var owner := get_viewport().gui_get_focus_owner()
	if owner: owner.release_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and GlobalCount.in_subtree_menu:
		AudioPlayer.play_FX(back_button, 5)
		accept_event()
		emit_signal("closed")
		GlobalCount.in_subtree_menu = false
		GlobalCount.stage_select_pause = false
		queue_free()

func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_slider.value / 100.0)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_slider.value / 100.0)

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_slider.value / 100.0)

func _on_back_pressed() -> void:
	GlobalCount.in_subtree_menu = false
	GlobalCount.stage_select_pause = false
	AudioPlayer.play_FX(back_button, 5)
	emit_signal("closed")
	queue_free()
	
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


func _on_window_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_set_window_mode("windowed")
	else:
		if !fullscreen_check.button_pressed:
			window_check.set_block_signals(true)
			window_check.button_pressed = true
			window_check.set_block_signals(false)
	
func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_set_window_mode("exclusive_fullscreen")
	else:
		if !window_check.button_pressed:
			fullscreen_check.set_block_signals(true)
			fullscreen_check.button_pressed = true
			fullscreen_check.set_block_signals(false)
	
func _set_window_mode(mode: String) -> void:
	ConfigFileHandler.apply_window_mode(mode)
	ConfigFileHandler.save_window_mode(mode)
	
	window_check.set_block_signals(true)
	fullscreen_check.set_block_signals(true)
	
	match mode:
		"windowed":
			window_check.button_pressed = true
			fullscreen_check.button_pressed = false
		"exclusive_fullscreen":
			window_check.button_pressed = false
			fullscreen_check.button_pressed = true
			
	window_check.set_block_signals(false)
	fullscreen_check.set_block_signals(false)
