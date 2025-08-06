extends Node

var action_names := {
	#Gameplay
	"Move": true,
	"Aim": true,
	"dash": false,
	"attack": false,
	"heavyattack": false,
	"charge": false,
	"transform": false,
	"pause": false,
	"interact": false,
	
	#Menu
	"MenuMove": true,
	"menu_up": false,
	"menu_down": false,
	"menu_left": false,
	"menu_right": false,
	"menu_select": false,
	"menu_cancel": false
}

var got_handles := false

var game_action_set
var current_action_set

var actions = {}
var action_states := {}

func init() -> void:
	Steam.input_device_connected.connect(_on_steam_input_device_connected)
	Steam.input_device_disconnected.connect(_on_steam_input_device_disconnected)
	
	Steam.runFrame()
	for pad in Steam.getConnectedControllers():
		_on_steam_input_device_connected(pad)
	#get_handles()
	print("action states: ", action_states)
	print("actions: ", actions)
	print(game_action_set)
	
func get_primary_pad() -> int:
	var arr := get_controllers()
	if arr.size() > 1:
		return arr[1]
	return -1
	
#func _process(_d):
	#Steam.runFrame()
	
func _on_steam_input_device_connected(input_handle: int) -> void:
	if not got_handles:
		get_handles()
	Steam.activateActionSet(input_handle, current_action_set)
	print("Device connected %s: " % str(input_handle))
	
func _on_steam_input_device_disconnected(input_handle: int) -> void:
	print("Device disconnected %s" % str(input_handle))
	
func get_handles() -> void:
	got_handles = true
	game_action_set = Steam.getActionSetHandle("GameControls")
	current_action_set = game_action_set
	get_action_handles(action_names)
	print("actions list: ", actions)
	
func get_action_handles(action_names: Dictionary) -> void:
	for action in action_names.keys():
		if action_names[action]:
			actions[action] = Steam.getAnalogActionHandle(action)
		else:
			actions[action] = Steam.getDigitalActionHandle(action)
		print("action_names[action] :", action_names[action])
		print("actions[action] :", actions[action])
	
			
func get_controllers() -> Array[int]:
	var controllers: Array[int] = [-1]
	var steam_controllers = Steam.getConnectedControllers()
	if steam_controllers:
		controllers.append_array(steam_controllers)
	return controllers
	
func get_vector(device: int) -> Vector2:
	if device >= 1:
		if not got_handles: return Vector2.ZERO
		var d := Steam.getAnalogActionData(device, actions["Move"])
		if not d.active:
			return Vector2.ZERO
		var v := Vector2(d.x, -d.y)
		return v.normalized()
	return Input.get_vector("left", "right", "up", "down")
	
func get_aim_vector(device: int) -> Vector2:
	if device < 0 or not got_handles: return Vector2.ZERO
	var d := Steam.getAnalogActionData(device, actions["Aim"])
	if not d.active: return Vector2.ZERO
	var v := Vector2(d.x, -d.y)
	if v.length() > 0.2:
		return v.normalized()
	return Vector2.ZERO
	
func get_action_state(device: int, action: String) -> Dictionary:
	if not action_states.get(device):
		action_states[device] = {}
	if not action_states[device].get(action):
		action_states[device][action] = { "held": false, "press_frame": -1, "release_frame": -1 }
	return action_states[device][action]
	
func set_action_state(device: int, action: StringName, currently_held: bool, current_frame: int) -> Dictionary:
	var previous_action_state = get_action_state(device, action)
	
	if currently_held and not previous_action_state.held:
		action_states[device][action].held = true
		action_states[device][action].press_frame = current_frame
	elif not currently_held and previous_action_state.held:
		action_states[device][action].held = false
		action_states[device][action].release_frame = current_frame
		
	return action_states[device][action]
	
func is_action_pressed(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		set_action_state(device, action, currently_held, current_frame)
		return currently_held
	return Input.is_action_pressed(action, exact_match)
	
func is_action_just_pressed(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		var action_state = set_action_state(device, action, currently_held, current_frame)
		return currently_held and action_state.press_frame == current_frame
	return Input.is_action_just_pressed(action, exact_match)
	
func is_action_just_released(device: int, action: StringName, exact_match: bool = false) -> bool:
	if device >= 0:
		if not got_handles: return false
		var current_frame = Engine.get_process_frames()
		var currently_held = Steam.getDigitalActionData(device, actions[action]).state
		var action_state = set_action_state(device, action, currently_held, current_frame)
		return not currently_held and action_state.release_frame == current_frame
		
	return Input.is_action_just_released(action, exact_match)
		
