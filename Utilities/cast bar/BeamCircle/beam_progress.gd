extends Node2D

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var shake_fade: float = 0.0
var shake_strength: float = 0.0

var rng = RandomNumberGenerator.new()

func _ready():
	texture_progress_bar.value = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(texture_progress_bar, "value", 100, 2).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(2).timeout
	queue_free()

#func apply_shake(random_strength: float, shake_time: float) -> void:
	#shake_strength = random_strength
	#shake_fade = shake_time
	#
#func _process(delta: float) -> void:
	#if shake_strength > 0:
		#shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		#
		#position = original_position + random_offset()
	#else:
		#position = original_position
		#
#func random_offset() -> Vector2:
	#return Vector2(
		#rng.randf_range(-shake_strength, shake_strength),
		#rng.randf_range(-shake_strength, shake_strength)
	#)
