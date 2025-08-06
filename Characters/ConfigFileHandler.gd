extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"
const DEFAULT_WINDOW_MODE := "exclusive_fullscreen"

const ASPECT := Vector2(16, 9)
const WINDOWED_SCALE := 0.80

func _apply_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, linear_to_db(clamp(linear, 0.0, 1.0)))
	
func apply_saved_audio() -> void:
	var audio = load_audio_settings()
	_apply_bus_volume("Master", audio["master_volume"])
	_apply_bus_volume("SFX", audio["sfx_volume"])
	_apply_bus_volume("Music", audio["music_volume"])
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), audio["muted"])

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "left", "A")
		config.set_value("keybinding", "right", "D")
		config.set_value("keybinding", "up", "W")
		config.set_value("keybinding", "down", "S")
		config.set_value("keybinding", "dash", "Space")
		config.set_value("keybinding", "attack", "mouse_1")
		config.set_value("keybinding", "heavyattack", "mouse_2")
		config.set_value("keybinding", "charge", "E")
		config.set_value("keybinding", "transform", "Q")
		
		#config.set_value("video", "fullscreen", true)
		#config.set_value("video", "screen_shake", false)
		
		config.set_value("audio", "master_volume", 0.5)
		config.set_value("audio", "sfx_volume", 0.5)
		config.set_value("audio", "music_volume", 0.5)
		
		config.set_value("audio", "muted", false)
		
		config.set_value("video", "window_mode", DEFAULT_WINDOW_MODE)
		config.set_value("video", "vsync", true)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
#func save_video_setting(key: String, value):
	#config.set_value("video", key, value)
	#config.save(SETTINGS_FILE_PATH)
	#
#func load_video_settings():
	#var video_settings = {}
	#for key in config.get_section_keys("video"):
		#video_settings[key] = config.get_value("video", key)
	#return video_settings
func reset_to_default() -> void:
	config.set_value("audio", "master_volume", 0.1)
	config.set_value("audio", "sfx_volume", 0.1)
	config.set_value("audio", "music_volume", 0.1)
	config.set_value("audio", "muted", false)
	
	config.set_value("video", "window_mode", DEFAULT_WINDOW_MODE)
	config.set_value("video", "vsync", true)
	config.save(SETTINGS_FILE_PATH)
	
func save_audio_setting(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	return {
		master_volume = float(config.get_value("audio", "master_volume", 0.5)),
		sfx_volume = float(config.get_value("audio", "sfx_volume",    0.5)),
		music_volume = float(config.get_value("audio", "music_volume",  0.5)),
		muted = bool(config.get_value("audio", "muted", false))
	}
	#var audio_settings = {}
	#for key in config.get_section_keys("audio"):
		#audio_settings[key] = config.get_value("audio", key)
		#
	#if !"muted" in audio_settings:
		#audio_settings["muted"] = false
		#config.set_value("audio", "muted", false)
		#config.save(SETTINGS_FILE_PATH)
	#return audio_settings
	
func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)
	
func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
			
		keybindings[key] = input_event
	return keybindings
	
func save_window_mode(mode: String) -> void:
	config.set_value("video", "window_mode", mode)
	config.save(SETTINGS_FILE_PATH)
	
func load_window_mode() -> String:
	return config.get_value("video", "window_mode", DEFAULT_WINDOW_MODE)
	
func apply_window_mode(mode: String) -> void:
	match mode:
		"exclusive_fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"windowed":
			var screen : Vector2i = DisplayServer.screen_get_size()
			var size : Vector2i = _calc_window_size(screen, WINDOWED_SCALE)
			_center_window_safe(size)
			
func _center_window_safe(size: Vector2i) -> void:
	var screen_id := DisplayServer.window_get_current_screen()
	var work_rect : Rect2i = DisplayServer.screen_get_usable_rect(screen_id)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(size)
	
	await get_tree().process_frame
	var outer : Vector2i = DisplayServer.window_get_size_with_decorations()
	
	var pos: Vector2i = work_rect.position + (work_rect.size - outer) / 2
	DisplayServer.window_set_position(pos)
	
func _calc_window_size(screen: Vector2i, scale: float) -> Vector2i:
	var w := int(screen.x * scale)
	var h := int(w * ASPECT.y / ASPECT.x)
	if h > screen.y * scale:
		h = int(screen.y * scale)
		w = int(h * ASPECT.x / ASPECT.y)
	return Vector2i(w, h)
	
func save_vsync(enabled: bool) -> void:
	config.set_value("video", "vsync", enabled)
	config.save(SETTINGS_FILE_PATH)
	
func load_vsync() -> bool:
	return bool(config.get_value("video", "vsync", true))
	
func save_muted(muted: bool) -> void:
	config.set_value("audio", "muted", muted)
	config.save(SETTINGS_FILE_PATH)
	
func load_muted() -> bool:
	return bool(config.get_value("audio", "muted", false))
	
func get_bool(section: String, key: String, default_val: bool) -> bool:
	return bool(config.get_value(section, key, default_val))
