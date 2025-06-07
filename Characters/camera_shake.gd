extends Camera2D

@export var shake_fade: float
@export_category("Follow Character")
@onready var player: CharacterBody2D = $"../Player"

@export_category("Camera Smoothing")
@export var smoothing_enabled : bool
@export_range(1, 10) var smoothing_distance : int = 8

var rng = RandomNumberGenerator.new()

var shake_hold_time: float = 0.0
@export var min_shake_threshold := 0.02
var shake_strength: float = 0.0

func _ready():
	GlobalCount.camera = self

func _physics_process(delta):
	var weight : float
	
	if player != null:
		var camera_position : Vector2
		
		if smoothing_enabled:
			weight = float(11 - smoothing_distance) / 100
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position

func apply_shake(random_strength : float, shake_time, hold_seconds: float = 0.0):
	shake_strength = random_strength
	shake_hold_time = hold_seconds
	shake_fade = shake_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength <= 0:
		offset = Vector2.ZERO
		return
	
	if shake_hold_time > 0.0:
		shake_hold_time -= delta
	else:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		if shake_strength < min_shake_threshold:
			shake_strength = 0.0
			
	offset = randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
