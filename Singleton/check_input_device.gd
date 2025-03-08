class_name CheckInputDevice
extends Node

static var is_mouse = true
var previous_axis_value = 0.0
var deadzone = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		is_mouse = true
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion):
	#and deadzone_check()):
		print("joypad input: ", event)
		is_mouse = false
	#elif event is InputEventJoypadMotion:
		#is_mouse = false
		#_handle_joypad_motion(event)
		
func deadzone_check():
	var deadzone = 0.5
	var joystick_vector = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1)).length()
	return deadzone < joystick_vector
	
static func get_input_type():
	return is_mouse
	
