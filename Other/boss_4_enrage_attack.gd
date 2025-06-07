extends Node2D
@onready var dark_wind_vfx: AnimatedSprite2D = $AttackVFX/DarkWindVFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dark_wind_vfx_mid: AnimatedSprite2D = $AttackVFXMiddle/DarkWindVFX
@onready var enrage_quad_telegraph_1: Sprite2D = $EnrageQuadTelegraph1
@onready var enrage_quad_telegraph_2: Sprite2D = $EnrageQuadTelegraph2
@onready var enrage_quad_telegraph_3: Sprite2D = $EnrageQuadTelegraph3
@onready var enrage_quad_telegraph_4: Sprite2D = $EnrageQuadTelegraph4
@onready var enrage_quad_telegraph_5: Sprite2D = $EnrageQuadTelegraph5

func _ready():
	animation_player.play("quad_1")
	await get_tree().create_timer(8).timeout
	animation_player.play("quad_2")
	await get_tree().create_timer(8).timeout
	animation_player.play("quad_3")
	await get_tree().create_timer(8).timeout
	animation_player.play("quad_4")
	await get_tree().create_timer(8).timeout
	animation_player.play("quad_mid")


func _on_dark_wind_vfx_animation_finished() -> void:
	dark_wind_vfx.rotation = randf() * TAU

func play_quad_vfx():
	dark_wind_vfx.play("default")

func play_mid_vfx():
	dark_wind_vfx_mid.play("default")
	
func camera_shake():
	GlobalCount.camera.apply_shake(30.0, 20.0)
