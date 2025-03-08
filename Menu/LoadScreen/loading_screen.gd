extends CanvasLayer

signal loading_screen_has_full_coverage

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _update_progress_bar(_new_value: float) -> void:
	pass
	
func _start_outro_animation() -> void:
	#await Signal(animation_player, "animation_finished")
	animation_player.play("end_load")
	await Signal(animation_player, "animation_finished")
	self.queue_free()
