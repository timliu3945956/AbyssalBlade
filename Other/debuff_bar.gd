extends Node2D
#@onready var icon_1: Label = $CenterContainer/DebuffIcons/Icon1
#@onready var icon_2: Label = $CenterContainer/DebuffIcons/Icon2
#@onready var icon_3: Label = $CenterContainer/DebuffIcons/Icon3
#@onready var icon_4: Label = $CenterContainer/DebuffIcons/Icon4
#@onready var count_down_1: Label = $CenterContainer2/Timers/CountDown1
#@onready var count_down_2: Label = $CenterContainer2/Timers/CountDown2
#@onready var count_down_3: Label = $CenterContainer2/Timers/CountDown3
#@onready var count_down_4: Label = $CenterContainer2/Timers/CountDown4

@onready var icons := [
	$CenterContainer/DebuffIcons/Icon1,
	$CenterContainer/DebuffIcons/Icon2,
	$CenterContainer/DebuffIcons/Icon3,
	$CenterContainer/DebuffIcons/Icon4
]

@onready var countdowns := [
	$CenterContainer2/Timers/CountDown1,
	$CenterContainer2/Timers/CountDown2,
	$CenterContainer2/Timers/CountDown3,
	$CenterContainer2/Timers/CountDown4
]

var DEBUFF_TIMES = [6, 10, 14, 18]
const ALL_DEBUFF_TEXTURES = [
	preload("res://sprites/GriefBoss/debuff icons/debuff_circle.png"),
	preload("res://sprites/GriefBoss/debuff icons/debuff_donut.png"),
	preload("res://sprites/GriefBoss/debuff icons/debuff_+.png"),
	preload("res://sprites/GriefBoss/debuff icons/debuff_X.png")
]

const BOSS_ATTACKS = [
	"in_attack",
	"out_attack",
	"+_attack",
	"x_attack"
]
var slot_timers = [0.0, 0.0, 0.0, 0.0]
var order : Array[int]

signal debuff_finished(attack_name: String)

func _ready() -> void:
	self.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.4)
	print("Debuffs spawned")
	randomize()
	
	order = [0, 1, 2, 3]
	order.shuffle()
	
	
	for i in range(4):
		var data = order[i]
		
		var sb := StyleBoxTexture.new()
		sb.texture = ALL_DEBUFF_TEXTURES[data]
		icons[i].add_theme_stylebox_override("normal", sb)
		
		slot_timers[i] = DEBUFF_TIMES[i]
		countdowns[i].text = str(slot_timers[i])
		
func _process(delta):
	for i in range(4):
		if slot_timers[i] <= 0:
			continue
		
		slot_timers[i] -= delta
		if slot_timers[i] < 0:
			slot_timers[i] = 0
		
		countdowns[i].text = str(int(ceil(slot_timers[i])))
		
		if slot_timers[i] == 0:
			var data = order[i]
			emit_signal("debuff_finished", BOSS_ATTACKS[data])
			icons[i].visible = false
			countdowns[i].visible = false
		#if slot_timers[i] > 0:
			#slot_timers[i] -= delta
			#if slot_timers[i] < 0:
				#slot_timers[i] = 0
				#
			#countdowns[i].text = str(int(slot_timers[i]))
			#
			#if slot_timers[i] == 0:
				#emit_signal("debuff_finished", BOSS_ATTACKS[i])
				#icons[i].visible = false
				#countdowns[i].visible = false
