class_name CheckInputDevice
extends Node

enum InputSource {KEYBOARD, CONTROLLER}
var activeInputSource = InputSource.KEYBOARD

signal InputSourceChanged(source)

func GetMovementVector():
	if activeInputSource == InputSource.KEYBOARD:
		return Input.get_vector("left", "right", "up", "down")
	return Vector2.ZERO
	
func GetActionPressed(actionName):
	return Input.is_action_pressed(actionName)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		setInputSource(InputSource.KEYBOARD)
		
func setInputSource(source):
	if activeInputSource != source:
		activeInputSource = source
		print("Input Source has changed to : ", source)
		InputSourceChanged.emit(source)
#static var is_mouse = true
#var _last_pad_time := 0.0
#const DEADZONE = 0.25
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_ALWAYS
#
#func _input(event: InputEvent):
	#match event:
		#InputEventJoypadMotion:
			#if abs(event.axis_value) > DEADZONE:
				#_mark_pad()
		#InputEventJoypadButton:
			#if event.pressed:
				#_mark_pad()
		#InputEventMouseButton, InputEventMouseMotion:
			#_mark_mouse()
		#InputEventKey:
			#_mark_mouse()
	##if event is InputEventKey or event is InputEventMouse:
		##is_mouse = true
	##elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
	###and deadzone_check()):
		##print("joypad input: ", event)
		##is_mouse = false
		##
		##
	##elif event is InputEventJoypadMotion:
		##is_mouse = false
		##_handle_joypad_motion(event)
		#
#func _physics_process(delta: float) -> void:
	#_last_pad_time += delta
	#if _last_pad_time > 2.0 and !is_mouse:
		#_mark_mouse()
#
#func _mark_pad() -> void:
	#is_mouse = false
	#_last_pad_time = 0.0
	#
#func _mark_mouse() -> void:
	#is_mouse = true
		#
#func deadzone_check():
	#var deadzone = 0.5
	#var joystick_vector = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1)).length()
	#return deadzone < joystick_vector
	#
#static func get_input_type():
	#return is_mouse
	#
