extends Node2D

@onready var jump_slam_attack: Sprite2D = $JumpSlamAttack
@onready var animated_sprite_2d_2: AnimatedSprite2D = $JumpSlamAttack/AnimatedSprite2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $JumpSlamAttack/AnimatedSprite2D
@onready var normal_attack_fire: GPUParticles2D = $NormalAttackFire
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_slam_collision: CollisionPolygon2D = $JumpSlam/JumpSlamCollision
@onready var collision_timer: Timer = $CollisionTimer


func _ready():
	animation_player.play("slam_telegraph")
	await animation_player.animation_finished
	#randomize()
	jump_slam_collision.disabled = false
	collision_timer.start()
	jump_slam_attack.rotation = randf() * TAU
	animated_sprite_2d_2.play("default")
	animated_sprite_2d.play("default")
	normal_attack_fire.emitting = true

func _on_animated_sprite_2d_2_animation_finished() -> void:
	queue_free()


func _on_collision_timer_timeout() -> void:
	jump_slam_collision.disabled = true
