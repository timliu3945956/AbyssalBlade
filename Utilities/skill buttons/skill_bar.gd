extends HBoxContainer
#@onready var skill_button_1:  utton = $TextureButton5
@onready var skill_button_1: Label = $TextureButton/Key
@onready var skill_button_2: Label = $TextureButton2/Key
@onready var skill_button_3: Label = $TextureButton3/Key
@onready var skill_button_4: Label = $TextureButton4/Key
@onready var skill_button_5: Label = $TextureButton5/Key
@onready var cooldown_1: TextureProgressBar = $TextureButton/Cooldown
@onready var cooldown_2: TextureProgressBar = $TextureButton2/Cooldown
@onready var cooldown_3: TextureProgressBar = $TextureButton3/Cooldown
@onready var cooldown_4: TextureProgressBar = $TextureButton4/Cooldown
@onready var cooldown_5: TextureProgressBar = $TextureButton5/Cooldown

@onready var left_click_only_mouse: Sprite2D = $TextureButton/LeftClickOnlyMouse
@onready var right_click_only_mouse: Sprite2D = $TextureButton2/RightClickOnlyMouse


func _ready() -> void:
	_load_keybindings_for_player()
	_update_skill_labels()
	cooldown_1.value = 0
	cooldown_2.value = 0
	cooldown_3.value = 0
	cooldown_5.value = 100
	
	
func _load_keybindings_for_player() -> void:
	var keybindings = ConfigFileHandler.load_keybindings()
	for action_name in keybindings.keys():
		InputMap.action_erase_events(action_name)
		
		InputMap.action_add_event(action_name, keybindings[action_name])

func _update_skill_labels():
	var events = InputMap.action_get_events("attack")
	if events.size() > 0:
		print("attack: ", events[0].as_text().trim_suffix(" (Physical)"))
		left_click_only_mouse.visible = true
		skill_button_1.visible = false
		skill_button_1.text = convert_event_to_string(events[0]) #events[0].as_text().trim_suffix(" (Physical)")
	else:
		skill_button_1.visible = true
		left_click_only_mouse.visible = false
		skill_button_1.text = ""
		
	var heavy_attack_event = InputMap.action_get_events("heavyattack")
	if heavy_attack_event.size() > 0:
		print("heavyattack: ", heavy_attack_event[0].as_text().trim_suffix(" (Physical)"))
		right_click_only_mouse.visible = true
		skill_button_2.visible = false
		skill_button_2.text = convert_event_to_string(heavy_attack_event[0]) #heavy_attack_event[0].as_text().trim_suffix(" (Physical)")
	else:
		skill_button_2.visible = true
		right_click_only_mouse.visible = false
		skill_button_2.text = ""
	
	var dash_event = InputMap.action_get_events("dash")
	if dash_event.size() > 0:
		print("dash: ", dash_event[0].as_text().trim_suffix(" (Physical)"))
		skill_button_3.text = dash_event[0].as_text().trim_suffix(" (Physical)")
	else:
		skill_button_3.text = ""
	
	var charge_event = InputMap.action_get_events("charge")
	if charge_event.size() > 0:
		print("charge: ", charge_event[0].as_text().trim_suffix(" (Physical)"))
		skill_button_4.text = charge_event[0].as_text().trim_suffix(" (Physical)")
	else:
		skill_button_4.text = ""
	
	var transform_event = InputMap.action_get_events("transform")
	if transform_event.size() > 0:
		print("transform: ", transform_event[0].as_text().trim_suffix(" (Physical)"))
		skill_button_5.text = transform_event[0].as_text().trim_suffix(" (Physical)")
	else:
		skill_button_5.text = ""
	
func convert_event_to_string(event: InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string(event.physical_keycode)
	
	elif event is InputEventMouseButton:
		match event.button_index:
			1:
				return "LMB"
			2:
				return "RMB"
			_:
				return event.as_text().trim_suffix(" (Physical)")
	
	return "Unknown"
	#var config_handler = get_node("res://Utilities/skill buttons/ConfigHandler.tscn")
	##var keybindings = ConfigFileHandler.load_keybindings()
	#print(keybindings)
	#skill_button_1.get_node("Key").text = convert_event_to_string(keybindings["attack"])
	#skill_button_2.get_node("Key").text = convert_event_to_string(keybindings["heavyattack"])
	#skill_button_3.get_node("Key").text = convert_event_to_string(keybindings["dash"])
	#skill_button_4.get_node("Key").text = convert_event_to_string(keybindings["charge"])
	#skill_button_5.get_node("Key").text = convert_event_to_string(keybindings["transform"])
#
#func convert_event_to_string(event: InputEvent) -> String:
	#if event is InputEventKey:
		#return OS.get_keycode_string(event.physical_keycode)
	#elif event is InputEventMouseButton:
		#return "mouse_" + str(event.button_index)
	#return "Unknown"
	
