extends Node2D

#@onready var controller_button: Label = $ControllerButton
@onready var controller_button: Label = $ControllerButton
@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = "[F]"

const TEX_XBOX := preload("res://UI/controller icons/X.png")
const TEX_PS := preload("res://UI/PS icons/Square.png")

var active_areas = []
var can_interact = true

func _ready() -> void:
	InputManager.InputSourceChanged.connect(_on_input_source_changed)
	_apply_prompt_mode(InputManager.activeInputSource)
	var sb := controller_button.get_theme_stylebox("normal") as StyleBoxTexture
	if sb is StyleBox:
		var fix := sb.duplicate()
		fix.content_margin_top = 2
		controller_button.add_theme_stylebox_override("normal", fix)
	
func _apply_prompt_mode(source: int) -> void:
	var pad = source == InputManager.InputSource.CONTROLLER
	controller_button.visible = pad
	label.visible = !pad
	
	if pad:
		_update_pad_texture()

func _on_input_source_changed(src: int) -> void:
	_apply_prompt_mode(src)

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(_delta):
	var pad = InputManager.activeInputSource == InputManager.InputSource.CONTROLLER
	var prompt : Node
	var hide : Node
	if pad:
		prompt = controller_button
		hide = label
	else:
		prompt = label
		hide = controller_button
		
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var nearest_area = active_areas[0]
		#label.text = base_text  #+ active_areas[0].action_name
		
		if not pad:
			label.text = base_text
			
		#var pos = nearest_area.global_position
		#pos.y -= nearest_area.prompt_offset_y
		#if pad:
			#pos.y += 2
		prompt.global_position = nearest_area.global_position
		prompt.global_position.y -= nearest_area.prompt_offset_y
		if pad:
			prompt.global_position.y += 6
		prompt.global_position.x -= prompt.size.x / 2
		prompt.show()
		hide.hide()
	else:
		prompt.hide()
		hide.hide()
		
	if InputManager.GetActionJustPressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _update_pad_texture() -> void:
	var tex : Texture2D
	if InputManager.usingPlayStationPad:
		tex = TEX_PS
	else:
		tex = TEX_XBOX
	
	var sb := controller_button.get_theme_stylebox("normal") as StyleBoxTexture
	if sb is StyleBoxTexture:
		var copy := sb.duplicate()
		copy.texture = tex
		controller_button.add_theme_stylebox_override("normal", copy)
#func _process(delta):
	
