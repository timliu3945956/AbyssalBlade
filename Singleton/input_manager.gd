extends Node
#class_name CheckInputDevice
enum InputSource {KEYBOARD, CONTROLLER}
var activeInputSource: int = InputSource.KEYBOARD
var usingPlayStationPad: bool = false

func _refresh_pad_type() -> void:
	usingPlayStationPad = controllerManager.is_playstation(controllerManager.activeController)

var _window_focused := true

signal InputSourceChanged(source)

@onready var controllerManager: Node = $ControllerManager
@onready var _win: Window = get_window()

const ACTION_TO_BTN := {
	"dash": JOY_BUTTON_A,
	"heavyattack": JOY_BUTTON_Y,
	"charge": JOY_BUTTON_X,
	"transform": JOY_BUTTON_LEFT_SHOULDER,
}


func _ready():
	_window_focused = _win.has_focus()
	_win.focus_entered.connect(func(): _window_focused = true)
	_win.focus_exited.connect(func(): _window_focused = false)
	_win.focus_exited.connect(ButtonCapture.clear)
	
	controllerManager.ControllerConnected.connect(onControllerConnected)
	controllerManager.ControllerDisconnected.connect(onControllerDisconnected)
	_refresh_pad_type()
	
func _game_active() -> bool:
	return _window_focused
	
func _release_all_actions() -> void:
	for action in InputMap.get_actions():
		if Input.is_action_pressed(action):
			Input.action_release(action)

func detectInitialInputSource():
	if controllerManager.activeController != -1:
		setInputSource(InputSource.CONTROLLER)
	else:
		setInputSource(InputSource.KEYBOARD)
	
func GetMovementVector():
	if !_game_active():
		return Vector2.ZERO
	if activeInputSource == InputSource.CONTROLLER:
		return controllerManager.GetControllerStickInput()
		#var pad := SteamControllerInput.get_primary_pad()
		#if pad != -1:
			#return SteamControllerInput.get_vector(pad)
		#return SteamControllerInput.get_vector(pad)
	return Input.get_vector("left", "right", "up", "down")
	
func GetActionPressed(action: StringName) -> bool:
	if !_game_active():
		return false
	if activeInputSource == InputSource.CONTROLLER:
		return ButtonCapture.held(action)
	return Input.is_action_pressed(action)
		#return controllerManager.IsControllerButtonPressed(action, null)
		#if btn != null:
			#return controllerManager.IsControllerButtonPressed(btn)
	#if activeInputSource == InputSource.CONTROLLER:
		#var pad := SteamControllerInput.get_primary_pad()
		#if pad != -1 and SteamControllerInput.is_action_pressed(pad, action):
			#return true
	
func GetActionJustPressed(action: StringName) -> bool:
	if !_game_active():
		return false
	if activeInputSource == InputSource.CONTROLLER:
		return ButtonCapture.just(action)
	return Input.is_action_just_pressed(action)
		#var pad := SteamControllerInput.get_primary_pad()
		#if pad != -1 and SteamControllerInput.is_action_just_pressed(pad, action):
			#return true
	
func GetActionJustReleased(action: StringName) -> bool:
	if !_game_active():
		return false
	if activeInputSource == InputSource.CONTROLLER:
		return ButtonCapture.released(action)
		
		#var pad := SteamControllerInput.get_primary_pad()
		#if pad != -1 and SteamControllerInput.is_action_just_released(pad, action):
			#return true
	return Input.is_action_just_released(action)
	
#func _process(_d):
	#var prev = activeInputSource
	#
	#if _steam_pad_active():
		#activeInputSource = InputSource.CONTROLLER
	#elif _keyboard_active():
		#activeInputSource = InputSource.KEYBOARD
		#
	#if activeInputSource != prev:
		#print("Input Source has changed to :", activeInputSource)
		
#func _steam_pad_active() -> bool:
	#var pad := SteamControllerInput.get_primary_pad()
	#if pad == -1:
		#return false
		#
	#return SteamControllerInput.get_vector(pad) != Vector2.ZERO or SteamControllerInput.is_action_pressed(pad, "attack")
#
#func _keyboard_active() -> bool:
	#return Input.get_action_strength("left") > 0.0 \
		#or Input.get_action_strength("right") > 0.0 \
		#or Input.get_action_strength("up") > 0.0 \
		#or Input.get_action_strength("down") > 0.0 \
		#or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		
func _input(event: InputEvent) -> void:
	if !_game_active():
		return
		
	if event is InputEventKey or event is InputEventMouse:
		setInputSource(InputSource.KEYBOARD)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventJoypadButton:
		#_refresh_pad_type()
		setInputSource(InputSource.CONTROLLER)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > controllerManager.analogDeadzone:
		#_refresh_pad_type()
		setInputSource(InputSource.CONTROLLER)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
func setInputSource(source):
	if activeInputSource == source:
		return
	activeInputSource = source
	#
	#if source == InputSource.KEYBOARD:
	ButtonCapture.clear()
	_release_all_actions()
	if get_viewport().gui_get_focus_owner():
		get_viewport().gui_get_focus_owner().release_focus()
		
	_refresh_pad_type()
	print("Input Source has changed to : ", source)
	InputSourceChanged.emit(source)
	
	#if activeInputSource != source:
		#activeInputSource = source
		#print("Input Source has changed to : ", source)
		#InputSourceChanged.emit(source)
		
func onControllerConnected(id):
	_refresh_pad_type()
	setInputSource(InputSource.CONTROLLER)
	
func onControllerDisconnected(id):
	_refresh_pad_type()
	setInputSource(InputSource.KEYBOARD)
