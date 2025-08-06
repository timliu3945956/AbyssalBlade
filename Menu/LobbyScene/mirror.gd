extends Node2D

const ROMAN := ["", "I", "II", "III", "IV", "V", ""]

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var stage_select: Control = $"../Player/CanvasLayer/StageSelect"
@onready var player: CharacterBody2D = $"../Player"

@onready var voronoi_background_red: Sprite2D = $Sprite2D3/Voronoi_BackgroundRed
@onready var voronoi_background_gold: Sprite2D = $Sprite2D3/Voronoi_BackgroundGold
#@onready var color_rect: ColorRect = $"../Player/CanvasLayer/ColorRect"
@onready var color_rect: ColorRect = $Sprite2D3/ColorRect

@onready var collision_shape_2d: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var click = preload("res://audio/sfx/Menu/click.mp3")

@onready var abyss_underlay: Sprite2D = $"../Player/CanvasLayer/AbyssUnderlay"
@onready var abyss_overlay: Sprite2D = $"../Player/CanvasLayer/AbyssOverlay"
@onready var transform_fire_bar: GPUParticles2D = $"../Player/CanvasLayer/TransformFireBar"
@onready var manabar: ProgressBar = $"../Player/CanvasLayer/Manabar"
@onready var dash_meter: ProgressBar = $"../Player/CanvasLayer/DashMeter"

#@onready var stage_label: Label = $StageNumber

@onready var stage_labels : Array = $StageNumbers.get_children()
@onready var symbol_change_audio: AudioStreamPlayer2D = $SymbolChangeAudio
@onready var portal_color_anim: AnimationPlayer = $PortalColorAnim
@onready var blue_door: AnimatedSprite2D = $BlueDoor
@onready var gold_door: Sprite2D = $GoldDoor


var tween: Tween
var current_index : int = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
	var saved_index: int = Global.player_data_slots[Global.current_slot_index].last_shown_stage
	if saved_index == -1:
		saved_index = 0
	_show_immediately(saved_index)
	
	#portal_color_anim.play("RESET")
	#await get_tree().process_frame
	var shader_material_red := voronoi_background_red.material as ShaderMaterial
	var shader_material_gold := voronoi_background_gold.material as ShaderMaterial
	var color_rect_material := color_rect.material as ShaderMaterial
	await get_tree().process_frame                                                      
	if Global.player_data_slots[Global.current_slot_index].gold_portal:
		shader_material_red.set_shader_parameter("alpha", 0.0)
		shader_material_gold.set_shader_parameter("alpha", 1.0)
		color_rect_material.set_shader_parameter("effect_color", Color(0.831, 0.741, 0.612))
		color_rect_material.set_shader_parameter("radius", 1.3)
		blue_door.visible = false
		gold_door.visible = true
	else:
		portal_color_anim.play("RESET")
	
func _on_interact():
	AudioPlayer.play_FX(click, 10)
	collision_shape_2d.disabled = true
	stage_select.visible = true
	GlobalCount.stage_select_pause = true
	GlobalCount.paused = true
	stage_select.check_button_focus()
	abyss_underlay.visible = false
	abyss_overlay.visible = false
	transform_fire_bar.visible = false
	manabar.visible = false
	dash_meter.visible = false
	
	stage_select._focus_seeded = true
	stage_select._prev_move = Vector2.ZERO
	
	if InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		if stage_select._last_pressed_idx == -1:
			stage_select._last_pressed_idx = 0
			
		var btn = stage_select.stage_buttons[stage_select._last_pressed_idx]
		btn.grab_focus()
		btn.button_pressed = true

func number_change(new_index : int) -> void:
	if new_index == current_index:
		return
	
	var old_label : Sprite2D = stage_labels[current_index]
	var new_label : Sprite2D = stage_labels[new_index]
	
	new_label.visible = true
	new_label.modulate.a = 0.0
	
	tween = get_tree().create_tween()
	tween.tween_property(old_label, "modulate:a", 0.0, 0.5)
	symbol_change_audio.play()
	tween.parallel().tween_property(new_label, "modulate:a", 1.0, 0.5)
	
	if new_index == 6:
		portal_color_anim.play("portal_gold")
		Global.player_data_slots[Global.current_slot_index].gold_portal = true
		Global.save_data(Global.current_slot_index)
		
	
	await tween.finished
	old_label.visible = false
	current_index = new_index
	
func _show_immediately(index : int) -> void:
	for i in stage_labels.size():
		stage_labels[i].visible = (i == index)
		stage_labels[i].modulate.a = 1.0
	current_index = index
