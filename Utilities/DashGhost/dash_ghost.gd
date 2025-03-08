extends Sprite2D

@onready var tween = get_tree().create_tween()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.set_trans(tween.TRANS_QUART)
	tween.set_ease(tween.EASE_OUT)

	tween.tween_property(self, 'modulate:a', 0.0, 0.5)
