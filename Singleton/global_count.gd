extends Node

var elapsed_time = 0.0
var boss_defeated = false
var timer_active = false

var camera : Camera2D
var healthbar : TextureProgressBar
var boss: Sprite2D

var can_pause = false
var can_charge: bool = false

var slash_count = 0
var surge_count = 0
var dash_count = 0
var dps_count = 0

var death_count = 0

var previous_scene_path = ""

var is_mouse_in_panel = false

var original_speed: bool = true
var stage_select_pause: bool = false

var is_time_running: bool = false

const NOTIFICATION_WM_QUIT_REQUEST = 1006

var in_subtree_menu: bool = false

var from_stage_select_enter: bool = true

var paused: bool = false
var first_time_play: bool = false

var boss_4_final_health: float = 100 #testing hp
var boss_4_final_player_mana: int = 10

var ominous_wind_music = preload("res://audio/sfx/dialogue/ominous wind sfx.wav")
var npc_talk = preload("res://audio/sfx/dialogue/npc dialogue.wav")

var show_adjust_control: bool = false

var abyss_mode: bool = false
#func _ready() -> void:

func reset_count():
	timer_active = false
	elapsed_time = 0.0
	slash_count = 0
	surge_count = 0
	dash_count = 0
	dps_count = 0
	in_subtree_menu = false
	stage_select_pause = false
	can_pause = true
	paused = false
	can_charge = false
	
	
func _physics_process(delta: float) -> void:
	if is_time_running:
		Global.player_data_slots[Global.current_slot_index].time_played += delta
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		GlobalCount.is_time_running = false
		Global.save_data(Global.current_slot_index)
		get_tree().quit()
#func slow_down_game():
	#if original_speed:
		#original_speed = false
		#var tween = get_tree().create_tween()
		#tween.tween_property(Engine, "time_scale", 0.4, 0.3)
	#
	#await get_tree().create_timer(0.3).timeout
	#if not original_speed:
		#original_speed = true
		#var tween = get_tree().create_tween()
		#tween.tween_property(Engine, "time_scale", 1.0, 0.1)
	#
	
