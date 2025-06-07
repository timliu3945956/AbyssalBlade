extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CleaveVFX/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $CleaveVFX/AnimatedSprite2D2
@onready var top_bottom_attack_2: AnimatedSprite2D = $CleaveVFX/TopBottomAttack2
@onready var sword_clockwise: Sprite2D = $Marker2D/SwordClockwise
@onready var sword_vfx_clockwise: AnimatedSprite2D = $Marker2D/SwordVFXClockwise


@onready var marker_2d: Marker2D = $Marker2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var player : CharacterBody2D
var direction: int

func _ready():
	#rotation = global_position.angle_to_point(player.global_position)
	camera_shake()
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
	top_bottom_attack_2.play("default")
	
	animation_player.play("attack")
	var tween = get_tree().create_tween()
	tween.tween_property(
		marker_2d, 
		"rotation",
		marker_2d.rotation + deg_to_rad(180), 
		0.3333)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	#else:
		#animation_player.play("attack_2")
		#var tween = get_tree().create_tween()
		#tween.tween_property(
			#marker_2d, 
			#"rotation",
			#marker_2d.rotation - deg_to_rad(180), 
			#0.3333)\
			#.set_trans(Tween.TRANS_SINE)\
			#.set_ease(Tween.EASE_IN_OUT)
		
	await get_tree().create_timer(1).timeout
		#await animated_sprite_2d.animation_finished
	queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "telegraph":
		#animation_player.play("attack")
		#animated_sprite_2d.play("default")
		#animated_sprite_2d_2.play("default")
		#top_bottom_attack_2.play("default")
		#await animated_sprite_2d.animation_finished
		#queue_free()
