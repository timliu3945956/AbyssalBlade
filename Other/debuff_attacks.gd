extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_vfx: AnimatedSprite2D = $InAttackVFX/FireVFX
@onready var dark_wind_vfx_in: AnimatedSprite2D = $InAttackVFX/DarkWindVFX
@onready var dark_wind_vfx_out: AnimatedSprite2D = $OutAttackVFX/DarkWindVFX
@onready var dark_circle_vfx: AnimatedSprite2D = $OutAttackVFX/DarkCircleVFX
@onready var dark_wind_plus_vfx: AnimatedSprite2D = $"+AttackVFX/DarkWindVFX"
@onready var dark_wind_x_vfx: AnimatedSprite2D = $xAttackVFX/DarkWindVFX

var player: CharacterBody2D
var hit_type: String

#func _ready():
	#global_position = player.global_position
	#animation_player.play(hit_type)
	#await animation_player.animation_finished
	#queue_free()

func in_fire():
	dark_wind_vfx_in.play("default")
	#fire_vfx.play("default")

func out_fire():
	dark_wind_vfx_out.play("default")

func plus_fire():
	dark_wind_plus_vfx.play("default")

func x_fire():
	dark_wind_x_vfx.play("default")

func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
