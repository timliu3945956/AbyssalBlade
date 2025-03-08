extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ranged_line_collision: CollisionPolygon2D = $Marker2D/Area2D2/RangedLineCollision

@onready var ranged_lightning_special_1: AnimatedSprite2D = $Marker2D/Marker2D/RangedLightningSpecial1
@onready var ranged_lightning_special_2: AnimatedSprite2D = $Marker2D/Marker2D/RangedLightningSpecial2
@onready var animated_sprite_2d_4: AnimatedSprite2D = $Marker2D/Sprite2D2/AnimatedSprite2D4

func _ready():
	animation_player.play("ranged_line")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animated_sprite_2d_4.play("default")
	animation_player.play("attack_anim")
	#ranged_lightning_special_1.play("default")
	#ranged_lightning_special_2.play("default")


func _on_animated_sprite_2d_4_animation_finished() -> void:
	queue_free()
