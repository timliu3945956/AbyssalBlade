extends Node
#class_name CheckInputDevice
enum InputSource {KEYBOARD, CONTROLLER}
var activeInputSource = InputSource.KEYBOARD

signal InputSourceChanged(source)
@onready var controllerManager: Node = $ControllerManager

func _ready():
	controllerManager.ControllerConnected.connect(onControllerConnected)
	controllerManager.ControllerDisconnected.connect(onControllerDisconnected)

func detectInitialInputSource():
	if controllerManager.activeController != -1:
		setInputSource(InputSource.CONTROLLER)
	else:
		setInputSource(InputSource.KEYBOARD)
	
func GetMovementVector():
	if activeInputSource == InputSource.KEYBOARD:
		return Input.get_vector("left", "right", "up", "down")
	if activeInputSource == InputSource.CONTROLLER:
		return controllerManager.GetControllerStickInput()
	return Vector2.ZERO
	
func GetActionPressed(actionName):
	return Input.is_action_pressed(actionName)
	
func GetActionJustPressed(actionName):
	return Input.is_action_just_pressed(actionName)
	
func GetActionJustReleased(actionName):
	return Input.is_action_just_released(actionName)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		setInputSource(InputSource.KEYBOARD)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		setInputSource(InputSource.CONTROLLER)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > controllerManager.analogDeadzone:
		setInputSource(InputSource.CONTROLLER)
		
func setInputSource(source):
	if activeInputSource != source:
		activeInputSource = source
		print("Input Source has changed to : ", source)
		InputSourceChanged.emit(source)
		
func onControllerConnected(id):
	setInputSource(InputSource.CONTROLLER)
	
func onControllerDisconnected(id):
	setInputSource(InputSource.KEYBOARD)
	
