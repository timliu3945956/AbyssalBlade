extends Node2D
var queue : Array
@export var max_radius := 100.0
@export var min_radius := 50.0
@export var outward_duration := 0.5
@export var hold_duration := 4.0
@export var return_duration := 0.5

@export var min_scale : float = 0.6
@export var max_scale : float = 1.2

@export var min_spin_deg_per_sec : float = 90.0
@export var max_spin_deg_per_sec : float = 360.0
@onready var sprite: Sprite2D = $Sprite2D

var _spin_speed : float
var origin : Vector2
var _target : Vector2

const IMAGES = [
	preload("res://Utilities/Effects/glass_1.png"),
	preload("res://Utilities/Effects/glass_2.png"),
	preload("res://Utilities/Effects/glass_3.png")
]

var pick_random_image = randi_range(0, 2)

func _ready():
	#origin = global_position
	sprite.texture = IMAGES[pick_random_image]
	var angle = randf() * TAU
	var radius = randf_range(min_radius, max_radius)
	_target = global_position + Vector2.RIGHT.rotated(angle) * radius
	
	var s := randf_range(min_scale, max_scale)
	sprite.scale = Vector2.ONE * s
	
	_spin_speed = randf_range(min_spin_deg_per_sec, max_spin_deg_per_sec) 
	if randf() < 0.5:
		_spin_speed *= -1
	else:
		_spin_speed *= 1
				
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", _target, outward_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_interval(hold_duration)
	tween.tween_property(self, "global_position", origin, return_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "queue_free"))

func _process(delta):
	sprite.rotation_degrees += _spin_speed * delta
	#sprite_2d.global_position = get_global_mouse_position()
	
#extends Line2D
#class_name Trails
