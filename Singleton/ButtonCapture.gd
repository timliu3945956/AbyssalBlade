extends Node

func clear() -> void:
	state.clear()
	right_stick = Vector2.ZERO

const PAD_MAP := {
	JOY_BUTTON_A: "dash",
	JOY_BUTTON_X: "interact",
	JOY_BUTTON_LEFT_SHOULDER: "charge",
	JOY_BUTTON_RIGHT_SHOULDER: "attack",
	#6: "pause"
}

const AXIS_MAP := {
	JOY_AXIS_TRIGGER_LEFT: "transform",
	JOY_AXIS_TRIGGER_RIGHT: "heavyattack"
}

const TRIGGER_THRESHOLD := 0.5
const DEADZONE := 0.3

var state := {}
var right_stick := Vector2.ZERO

func _input(ev: InputEvent) -> void:
	if ev is InputEventJoypadButton and PAD_MAP.has(ev.button_index):
		print(ev.button_index)
		_update_state(PAD_MAP[ev.button_index], ev.pressed)
	elif ev is InputEventJoypadMotion:
		if AXIS_MAP.has(ev.axis):
			_update_state(AXIS_MAP[ev.axis], ev.axis_value > TRIGGER_THRESHOLD)
		if ev.axis == JOY_AXIS_RIGHT_X:
			right_stick.x = ev.axis_value
		elif ev.axis == JOY_AXIS_RIGHT_Y:
			right_stick.y = -ev.axis_value
		#return
func _process(_d):
	for s in state.values():
		s["just"] = false
		s["released"] = false
		
func _update_state(action: String, pressed: bool) -> void:
	var s = state.get(action, null)
	if s == null:
		s = {held = false, just=false, released=false}
	
	var was = s.held
	s.held = pressed
	s.just = pressed and not was
	s.released = !pressed and was
	state[action] = s
	
func held(a: String) -> bool: return state.get(a, {}).get("held", false)
func just(a: String) -> bool: return state.get(a, {}).get("just", false)
func released(a: String) -> bool: return state.get(a, {}).get("released", false)
func right_vec() -> Vector2:
	if right_stick.length() > DEADZONE:
		return right_stick.normalized()
	else:
		return Vector2.ZERO
