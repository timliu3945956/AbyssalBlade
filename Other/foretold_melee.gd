extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var vfx: Sprite2D = $vfx
@onready var animated_sprite_2d_2: AnimatedSprite2D = $vfx/AnimatedSprite2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $vfx/AnimatedSprite2D
@onready var normal_attack_fire: GPUParticles2D = $NormalAttackFire
@onready var foretold_audio_2: AudioStreamPlayer2D = $ForetoldAudio2

func _ready():
	animation_player.play("foretold_telegraph")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	randomize()
	vfx.rotation = randf() * TAU
	animated_sprite_2d_2.play("default")
	animated_sprite_2d.play("default")
	foretold_audio_2.play()
	normal_attack_fire.emitting = true
	collision.disabled = false
	await get_tree().create_timer(0.0833).timeout
	collision.disabled = true

#func _on_animated_sprite_2d_2_animation_finished() -> void:
	#queue_free()


func _on_foretold_audio_2_finished() -> void:
	queue_free()
