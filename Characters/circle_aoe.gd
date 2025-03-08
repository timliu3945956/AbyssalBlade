extends Node2D

@export var fade_speed = 1.0

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var eruption_audio: AudioStreamPlayer2D = $EruptionAudio

var CircleEffect = preload("res://circle_effect.tscn")

func _ready():
	animator.frame = 0
	animator.play("CircleAOE")
	#var tween = get_tree().create_tween()
	#tween.tween_property(animator, "modulate:a", 255, 1)

func _process(delta):
	animator.modulate.a = min(255, animator.modulate.a + delta * fade_speed)
	await get_tree().create_timer(2).timeout
	
func _on_animated_sprite_2d_animation_finished() -> void:
	animator.visible = false
	var circleEffect = CircleEffect.instantiate()
	var bossroom = get_tree().current_scene
	circleEffect.position = position
	bossroom.add_child(circleEffect)
	eruption_audio.play()
	
func knockback_circle():
	await get_tree().create_timer(2).timeout
