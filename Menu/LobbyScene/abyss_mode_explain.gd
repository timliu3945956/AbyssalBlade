extends Control
@onready var click = preload("res://audio/sfx/Menu/click.mp3")
@onready var confirm_button: Button = $CanvasLayer/Panel/VBoxContainer/ConfirmButton

var player

func _ready():
	InputManager.InputSourceChanged.connect(_apply_input_source)
	_apply_input_source(InputManager.activeInputSource)
	AudioPlayer.play_FX(click, 10)
	
func _apply_input_source(source: int) -> void:
	var pad = source == InputManager.InputSource.CONTROLLER
	
	if pad:
		confirm_button.grab_focus()

func _on_confirm_button_pressed() -> void:
	player.canvas_layer.visible = true
	player.set_process(true)
	player.set_physics_process(true)
	GlobalCount.stage_select_pause = false
	GlobalCount.in_subtree_menu = false
	AudioPlayer.play_FX(click, 10)
	queue_free()
