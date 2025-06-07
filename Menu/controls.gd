extends Control

@onready var input_button_scene = preload("res://Menu/input_button.tscn")
#@onready var action_list: GridContainer = $PanelContainer/MarginContainer/ActionList
#@onready var action_list: GridContainer = $ActionList

#@onready var action_list: GridContainer = $MarginContainer/ActionList

@onready var action_list: VBoxContainer = $MarginContainer/ActionList

@onready var master_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/SFXSlider
@onready var music_slider: HSlider = $AudioOptions/PanelContainer2/VBoxContainer/MusicSlider

@onready var click = preload("res://audio/sfx/Menu/click.mp3")
@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")
#@onready var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
#@onready var menu_music: AudioStreamPlayer2D = $MenuMusic

@onready var description_container: Control = $Description

#@onready var guide_player: VideoStreamPlayer = $Video/Panel/VideoStreamPlayer
#@onready var guide_player: VideoStreamPlayer = $Video/Panel/AspectRatioContainer/VideoStreamPlayer
@onready var guide_player: VideoStreamPlayer = $Video/VideoMask/AspectRatioContainer/VideoStreamPlayer


const ACTION_TO_DESC := {
	"up": "Move",
	"down": "Move",
	"left": "Move",
	"right": "Move",
	"dash": "Dash",
	"attack": "Attack",
	"heavyattack": "HeavyAttack",
	"charge": "Charge",
	"transform": "Surge"
}

var _desc_panels: Dictionary

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up": "Move Up",
	"down": "Move Down",
	"left": "Move Left",
	"right": "Move Right",
	"dash": "Dash",
	"attack": "Slash",
	"heavyattack": "Cleave",
	"charge": "Charge",
	"transform": "Surge"
}

const GUIDE_STREAMS := {
	"Move": preload("res://Utilities/menu/tutorial videos/guide_move.ogv"),
	"Dash": preload("res://Utilities/menu/tutorial videos/guide_dash.ogv"),
	"Attack": preload("res://Utilities/menu/tutorial videos/guide_slash.ogv"),
	"HeavyAttack": preload("res://Utilities/menu/tutorial videos/guide_cleave.ogv"),
	"Charge": preload("res://Utilities/menu/tutorial videos/guide_charge.ogv"),
	"Surge": preload("res://Utilities/menu/tutorial videos/guide_surge.ogv")
}

var _current_guide_key : String = ""
const DEFAULT_GUIDE_KEY := "Move"
signal closed

func _ready() -> void:
	_load_keybindings_from_settings()
	_create_action_list()
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	print(linear_to_db(audio_settings.music_volume))
	master_slider.value = min(audio_settings.master_volume, 1.0) * 100
	sfx_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	music_slider.value = min(audio_settings.music_volume, 1.0) * 100
	
	_create_action_list()
	_cache_description_panels()
	
	_show_description(DEFAULT_GUIDE_KEY)
	_play_guide(DEFAULT_GUIDE_KEY)
	
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
			var event_text = events[0].as_text().trim_suffix(" (Physical)")
			#if events[0] is InputEventMouseButton:
				#match events[0].button_index:
					#MOUSE_BUTTON_LEFT:
						#event_text = "lmb"
					#MOUSE_BUTTON_RIGHT:
						#event_text = "rmb"
					#_:
						#event_text = event_text
			input_label.text = event_text
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		var desc_key : String = ACTION_TO_DESC.get(action, "")
		button.set_meta("desc_key", desc_key)
		
		#mouse + keyboard focus -> show panel
		button.mouse_entered.connect(_on_button_hovered.bind(button))
		button.focus_entered.connect(_on_button_hovered.bind(button))
		
		#button.mouse_exited.connect(_hide_all_panels)
		
		#
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_button_hovered(button: Button) -> void:
	var key : String = button.get_meta("desc_key")
	if key != "":
		_show_description(key)
		_play_guide(key)
		
func _show_description(key: String) -> void:
	for k in _desc_panels:
		_desc_panels[k].visible = (k == key)

func _play_guide(desc_key: String) -> void:
	if !GUIDE_STREAMS.has(desc_key):
		if _current_guide_key != "":
			guide_player.stop()
			guide_player.visible = false
			_current_guide_key = ""
		return
	
	if desc_key == _current_guide_key and guide_player.is_playing():
		return
		
	guide_player.stream = GUIDE_STREAMS[desc_key]
	guide_player.visible = true
	guide_player.play()
	
	_current_guide_key = desc_key
	#else:
		#guide_player.stop()
		#guide_player.visible = false
		
func _on_input_button_pressed(button, action):
	AudioPlayer.play_FX(click, 0)
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
	#if event.is_action_pressed("ui_cancel"):
		#TransitionScreen.is_transitioning = true
		#AudioPlayer.play_FX(back_button, 0)
		#TransitionScreen.transition()
		#await TransitionScreen.on_transition_finished
		#if GlobalCount.previous_scene_path != "":
			#get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
		#elif GlobalCount.previous_scene_path == null:
			#print("No previous scene to return to.")
		#else:
			#print("No previous scene to return to.")
		
	if event.is_action_pressed("ui_cancel"):
		
		AudioPlayer.play_FX(back_button, -10)
		accept_event()
		emit_signal("closed")
		GlobalCount.in_subtree_menu = false
		queue_free()
		
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	
func _cache_description_panels() -> void:
	_desc_panels.clear()
	for p in description_container.get_children():
		_desc_panels[p.name] = p
		
func _hide_all_panels() -> void:
	for p in _desc_panels.values():
		p.visible = false
	
func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()
	
	
func _on_back_pressed() -> void:
	GlobalCount.in_subtree_menu = false
	guide_player.stop()
	AudioPlayer.play_FX(back_button, -10)
	emit_signal("closed")
	#AudioPlayer.play_FX(back_button, 10)
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	#if GlobalCount.previous_scene_path != "":
		#get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
	#else:
		#print("No previous scene to return to.")
	queue_free()


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("master_volume", master_slider.value / 100)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("sfx_volume", sfx_slider.value / 100)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_setting("music_volume", music_slider.value / 100)
