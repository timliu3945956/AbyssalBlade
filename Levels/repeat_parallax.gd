extends ParallaxLayer

@export var pixels_per_second := 20.0

func _process(delta: float) -> void:
	motion_offset.x += pixels_per_second * delta
	if motion_offset.x >= motion_mirroring.x:
		motion_offset.x -= motion_mirroring.x
