extends Button

var focused: bool = false
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if !InputCheck.is_mouse:
		#grab_focus()
		#focused = true
		


func _input(event):
	if event is InputEventJoypadButton or (event is InputEventJoypadMotion):
		if !focused:
			focused = true
			grab_focus()
	else:
		if focused:
			focused = false
			release_focus()
