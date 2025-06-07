extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dark_wind_vfx: AnimatedSprite2D = $AttackVFX/DarkWindVFX

func _ready():
	animation_player.play("attack")
	await animation_player.animation_finished
	queue_free()
	
func wind_vfx():
	dark_wind_vfx.play("default")
