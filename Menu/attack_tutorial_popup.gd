extends Control


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5)
	await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(3).timeout
	var tween_fadeout = get_tree().create_tween()
	tween_fadeout.tween_property(self, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _process(delta: float) -> void:
	pass
