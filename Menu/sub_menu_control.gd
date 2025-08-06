extends Control

@onready var sub_menu_button: Button = $SubMenuButton
@onready var controller_interact_button: Sprite2D = $ControllerInteractButton

const TEX_XBOX : Texture2D = preload("res://UI/controller icons/Menu.png")
const TEX_PS : Texture2D = preload("res://UI/PS icons/Menu.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputManager.InputSourceChanged.connect(_on_input_source_changed)
	_apply_input_mode(InputManager.activeInputSource)
	
func _apply_input_mode(source:int) -> void:
	var using_pad := source == InputManager.InputSource.CONTROLLER
	
	sub_menu_button.visible = !using_pad
	controller_interact_button.visible = using_pad
	
	if using_pad:
		if InputManager.usingPlayStationPad:
			controller_interact_button.texture = TEX_PS
		else:
			controller_interact_button.texture = TEX_XBOX

func _on_input_source_changed(source:int) -> void:
	_apply_input_mode(source)
