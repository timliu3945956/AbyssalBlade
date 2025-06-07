extends Node2D

const ROMAN := ["", "I", "II", "III", "IV", "V"]

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var stage_select: Control = $"../Player/CanvasLayer/StageSelect"
@onready var player: CharacterBody2D = $"../Player"
@onready var color_rect: ColorRect = $"../Player/CanvasLayer/ColorRect"
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

var tween: Tween
var current_index : int = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
	var saved_index: int = Global.player_data_slots[Global.current_slot_index].last_shown_stage
	if saved_index == -1:
		saved_index = 0
	_show_immediately(saved_index)
	#if Global.player_data_slots[Global.current_slot_index].last_shown_stage == -1:
		#target_idx = 0
	#else:
		#target_idx = Global.player_data_slots[Global.current_slot_index].last_shown_stage
	#
	#stage_label.text = ROMAN[target_idx]
	
func _calc_current_stage() -> int:
	var stage := 0
	if !Global.player_data_slots[Global.current_slot_index].first_play_1:
		stage = 1
	if !Global.player_data_slots[Global.current_slot_index].first_play_2:
		stage = 2
	if !Global.player_data_slots[Global.current_slot_index].first_play_3:
		stage = 3
	if !Global.player_data_slots[Global.current_slot_index].first_play_4:
		stage = 4
	return stage
	
func _on_interact():
	AudioPlayer.play_FX(click, -10)
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
	
	await tween.finished
	old_label.visible = false
	current_index = new_index
	
func _show_immediately(index : int) -> void:
	for i in stage_labels.size():
		stage_labels[i].visible = (i == index)
		stage_labels[i].modulate.a = 1.0
	current_index = index
