extends Node

var elapsed_time = 0.0
var boss_defeated = false
var timer_active = false

var camera : Camera2D
var healthbar : ProgressBar

var can_pause = false

var slash_count = 0
var surge_count = 0
var dash_count = 0
var dps_count = 0

var death_count = 0

var previous_scene_path = ""

var is_mouse_in_panel = false

func reset_count():
	timer_active = false
	elapsed_time = 0.0
	slash_count = 0
	surge_count = 0
	dash_count = 0
	dps_count = 0
