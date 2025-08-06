extends Node

signal ControllerConnected(deviceId)
signal ControllerDisconnected(deviceId)

var connectedControllers = {}
var activeController = -1

@export var analogDeadzone = 0.4 #0.3
@export var triggerThreshold = 0.5

func _ready() -> void:
	for deviceID in Input.get_connected_joypads():
		registerController(deviceID)
	Input.joy_connection_changed.connect(onJoyConnectionChanged)
	
func registerController(id):
	var controllerName = Input.get_joy_name(id)
	connectedControllers[id] = {
		"name" : controllerName,
		"guid" : Input.get_joy_guid(id)
	}
	print("Controller Connected! %s (id:%s)" % [controllerName, id])
	
	if activeController == -1:
		activeController = id
		
	ControllerConnected.emit(id)
	
	pass
	
func deregisterController(id):
	if connectedControllers.has(id):
		var controllerName = connectedControllers[id].name
		print("Controller disonnected! %s (id:%s)" % [controllerName, id])
		connectedControllers.erase(id)
		
		if activeController == id:
			activeController = -1
			if not connectedControllers.is_empty():
				activeController = connectedControllers.keys()[0]
		ControllerDisconnected.emit(id)
	
func onJoyConnectionChanged(id, connected):
	if connected:
		registerController(id)
	else:
		deregisterController(id)
	pass

func GetControllerList():
	return connectedControllers
	
func GetActiveController():
	return activeController
	
func SetActiveController(id):
	if connectedControllers.has(id):
		activeController = id
		return true
	return false
	
func GetControllerStickInput(deviceid = -1, leftstick = true):
	if deviceid == -1:
		deviceid = activeController
	if deviceid == -1 or not connectedControllers.has(deviceid):
		return Vector2.ZERO
	
	var xAxies = JOY_AXIS_LEFT_X if leftstick else JOY_AXIS_RIGHT_X
	var yAxies = JOY_AXIS_LEFT_Y if leftstick else JOY_AXIS_RIGHT_Y
	
	var inputVector = Vector2(
		Input.get_joy_axis(deviceid, xAxies),
		Input.get_joy_axis(deviceid, yAxies)
		)
		
	if inputVector.length() < analogDeadzone:
		return Vector2.ZERO
	return inputVector
	
func IsControllerButtonPressed(button, deviceid = -1):
	if deviceid == -1:
		deviceid = activeController
	if deviceid == -1 or not connectedControllers.has(deviceid):
		return false
	return Input.is_joy_button_pressed(button, deviceid)
	
func IsControllerTriggerPressed(deviceid, leftTrigger = true):
	if deviceid == -1:
		deviceid = activeController
	if deviceid == -1 or not connectedControllers.has(deviceid):
		return 0.0
	
	var axis = JOY_AXIS_TRIGGER_LEFT if leftTrigger else JOY_AXIS_TRIGGER_RIGHT
	var value = Input.get_joy_axis(deviceid, axis)
	
	value = (value + 1) / 2
	
	return value if value > triggerThreshold else 0.0
	
func is_playstation(id: int) -> bool:
	if not connectedControllers.has(id):
		return false
	var name = connectedControllers[id].name.to_lower()
	
	return name.find("playstation") != -1 \
		or name.find("ps4") != -1 \
		or name.find("ps5") != -1 \
		or name.find("dualsense") != -1 \
		or name.find("dualshock") != -1
