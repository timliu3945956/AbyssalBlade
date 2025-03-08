extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d_7: AnimatedSprite2D = $AnimatedSprite2D7
@onready var animated_sprite_2d_8: AnimatedSprite2D = $AnimatedSprite2D8
@onready var particles_1: GPUParticles2D = $particles1
@onready var particles_2: GPUParticles2D = $particles2


func _ready():
	animation_player.play("line_attack")
	await get_tree().create_timer(0.9996).timeout
	
	animated_sprite_2d_7.play("default")
	animated_sprite_2d_8.play("default")
	particles_1.emitting = true
	particles_2.emitting = true
	

func _on_animated_sprite_2d_7_animation_finished() -> void:
	queue_free()
