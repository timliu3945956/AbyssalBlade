extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var red_zap_1: AnimatedSprite2D = $Marker2D/Node2D/RedZap1
@onready var red_zap_2: AnimatedSprite2D = $Marker2D/Node2D/RedZap2

@onready var animated_sprite_2d_4: AnimatedSprite2D = $Marker2D/Sprite2D2/AnimatedSprite2D4
#@onready var particles: GPUParticles2D = $Marker2D/Particles

func _ready():
	red_zap_1.play("default")
	red_zap_2.play("default")
	animated_sprite_2d_4.play("default")
	animation_player.play("attack_anim")
	#particles.emitting = true
	camera_shake()
	#animation_player.play("telegraph_fast")

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	

func _on_red_zap_1_animation_finished() -> void:
	self.queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
