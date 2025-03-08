extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var red_zap_1: AnimatedSprite2D = $Marker2D/Node2D/RedZap1
@onready var red_zap_2: AnimatedSprite2D = $Marker2D/Node2D/RedZap2
@onready var red_zap_3: AnimatedSprite2D = $Marker2D/Node2D/RedZap3

@onready var animated_sprite_2d_4: AnimatedSprite2D = $Marker2D/Sprite2D2/AnimatedSprite2D4
@onready var particles: GPUParticles2D = $Marker2D/Particles
#@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/Sprite2D2/AnimatedSprite2D
var random_vfx = randi_range(1, 2)
@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/AnimatedSprite2D

func _ready():
	red_zap_1.play("default")
	red_zap_2.play("default")
	red_zap_3.play("default")

	#animated_sprite_2d_4.play("default")
	animation_player.play("attack_anim")
	match random_vfx:
		1:
			animated_sprite_2d.play("default1")
		2:
			animated_sprite_2d.play("default2")
		#3:
			#animated_sprite_2d.play("default3")
		#4:
			#animated_sprite_2d.play("default4")
	particles.emitting = true
	camera_shake()
	#animation_player.play("telegraph_fast")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

#func _on_red_zap_1_animation_finished() -> void:
	#queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
