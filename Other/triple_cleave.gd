extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spit_attack_white: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttack/SpitAttackWhite
@onready var spit_attack_red: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttack/SpitAttackRed
var player : CharacterBody2D

func _ready():
	spit_attack_white.rotation = randf_range(0.0, TAU)
	spit_attack_red.rotation = randf_range(0.0, TAU)
	rotation = global_position.angle_to_point(player.global_position)
	animation_player.play("cleave_attack")

func cleave_vfx():
	spit_attack_white.play("default")
	spit_attack_red.play("default")
	await spit_attack_white.animation_finished
	queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
