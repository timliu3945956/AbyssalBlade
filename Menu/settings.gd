extends Control

@onready var input_button_scene = preload("res://Menu/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

@onready var master_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/SFXSlider
@onready var music_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MusicSlider

@onready var button_sound: AudioStreamPlayer2D = $ButtonSound
@onready var game_start_fx = preload("res://audio/sfx/Menu/Game Start.wav")
@onready var back_button = preload("res://audio/sfx/Menu/Back.wav")
#@onready var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up": "Move Up",
	"down": "Move Down",
	"left": "Move Left",
	"right": "Move Right",
	"dash": "Dash",
	"attack": "Attack",
	"heavyattack": "Heavy Attack",
	"charge": "Charge",
	"transform": "Surge"
}

func _ready() -> void:
	_load_keybindings_from_settings()
	_create_action_list()
	GlobalCount.can_pause = false
	
	
	#var video_settings = ConfigFileHandler.load_video_settings()
	var audio_settings = ConfigFileHandler.load_audio_settings()
	print(linear_to_db(audio_settings.music_volume))
	master_slider.value = min(audio_settings.master_volume, 1.0) * 100
	sfx_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	music_slider.value = min(audio_settings.music_volume, 1.0) * 100
	
	_create_action_list()
	#var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
	AudioPlayer.play_music(menu_music.stream, -10)
	
func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	button_sound.play()
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# Turn double click into single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
	if TransitionScreen.is_transitioning:
		return
	if event.is_action_pressed("ui_cancel"):
		TransitionScreen.is_transitioning = true
		AudioPlayer.play_FX(back_button, -15)
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		if GlobalCount.previous_scene_path != "":
			get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
		elif GlobalCount.previous_scene_path == null:
			print("No previous scene to return to.")
		else:
			print("No previous scene to return to.")
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	
func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()
	
func _on_back_pressed() -> void:
	AudioPlayer.play_FX(back_button, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	if GlobalCount.previous_scene_path != "":
		get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
	else:
		print("No previous scene to return to.")


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_slider.value / 100)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_slider.value / 100)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_slider.value / 100)
