extends Node2D

@onready var fireball_drop: AnimatedSprite2D = $FireballDrop
@onready var fireball_ground: AnimatedSprite2D = $ColorRect/FireballGround
@onready var aura_fire: AnimatedSprite2D = $AuraFire2
@onready var aura_fire_1: AnimatedSprite2D = $AuraFire1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("meteor_strike")
	fireball_drop.play("default")
	fireball_ground.play("default")
	aura_fire.play("default")
	aura_fire_1.play("default")
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
