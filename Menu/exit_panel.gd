extends Control
@onready var yes_button: Button = $Panel/VBoxContainer/YesButton
@onready var no_button: Button = $Panel/VBoxContainer/NoButton

func _ready():
	InputManager.InputSourceChanged.connect(_apply_input_source)
	_apply_input_source(InputManager.activeInputSource)
	
func _on_no_button_pressed() -> void:
	queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_no_button_pressed()
		accept_event()

func _on_yes_button_pressed() -> void:
	GlobalCount.is_time_running = false
	Global.save_data(Global.current_slot_index)
	get_tree().quit()
	
func _apply_input_source(source: int) -> void:
	var pad = source == InputManager.InputSource.CONTROLLER
	
	if pad:
		yes_button.grab_focus()
