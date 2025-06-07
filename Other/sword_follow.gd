extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	self.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	animation_player.play("sword_anim")
	await get_tree().create_timer(3).timeout
	animation_player.play("sword_blink")
	await get_tree().create_timer(0.4).timeout
	queue_free()
