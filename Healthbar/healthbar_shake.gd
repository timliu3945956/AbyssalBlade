extends "res://Healthbar/healthbar.gd"

@export var shake_fade: float

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0
var original_position : Vector2

func _ready():
	GlobalCount.healthbar = self
	original_position = position

func apply_shake(random_strength : float, shake_time : float):
	shake_strength = random_strength
	shake_fade = shake_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		position = original_position + randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
