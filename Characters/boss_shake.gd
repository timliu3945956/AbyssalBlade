extends Sprite2D

@export var default_strength : float = 12.0
@export var default_duration : float = 0.35
@export var decay_rate : float = 16.0

var _rng := RandomNumberGenerator.new()
var _origin : Vector2
var _strength : float = 0.0
var _time_left : float = 0.0

func _ready() -> void:
	_origin = position
	_rng.randomize()
	set_process(false)
	
func start_shake(strength = default_strength, duration = default_duration) -> void:
	print("STARTING BOSS SHAKE HERE")
	_origin = position
	_strength = strength
	_time_left = duration
	set_process(true)
	
	
func _process(delta: float) -> void:
	if _time_left <= 0.0:
		position = _origin
		set_process(false)
		return
		
	_time_left -= delta
	_strength = maxf(_strength - decay_rate * delta, 0.0)
	
	var offset := Vector2(
		_rng.randf_range(-1.0, 1.0),
		_rng.randf_range(-1.0, 1.0)
	).normalized() * _strength
	position = _origin + offset
