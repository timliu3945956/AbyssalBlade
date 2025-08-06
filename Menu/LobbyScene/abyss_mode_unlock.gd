extends Control
@onready var click = preload("res://audio/sfx/Menu/click.mp3")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var confirm_button: Button = $CanvasLayer/Panel/VBoxContainer/ConfirmButton
@onready var panel: Panel = $CanvasLayer/Panel

var pressed: bool = false

func _ready():
	
	panel.visible = false
	await get_tree().create_timer(2.5).timeout
	InputManager.InputSourceChanged.connect(_apply_input_source)
	_apply_input_source(InputManager.activeInputSource)
	AudioPlayer.play_FX(click, 10)
	panel.visible = true
	
func _apply_input_source(source: int) -> void:
	var pad = source == InputManager.InputSource.CONTROLLER
	
	if pad:
		confirm_button.grab_focus()

func _on_confirm_button_pressed() -> void:
	if pressed:
		return
	pressed = true
	
	AudioPlayer.play_FX(click, 10)
	panel.visible = false
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")
	
	#queue_free()
