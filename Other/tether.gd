extends Node2D

@export var base_length: float = 100.0
@onready var line_2d: Line2D = $Line2D
@onready var laser_middle: GPUParticles2D = $Line2D/LaserMiddle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var point1: Vector2
var player: CharacterBody2D
var set_timer: float = 3.0

func _ready():
	timer.wait_time = set_timer
	timer.start()
	animation_player.play("line_start")
	
	
func _process(delta):
	if not is_instance_valid(player):
		return
		
	var target_global: Vector2 = player.global_position + Vector2(0, -8)
	var target_local: Vector2 = line_2d.to_local(target_global)
	#var distance = global_position.distance_to(player.global_position + Vector2(0, -8))
	#rotation = ((player.global_position + Vector2(0, -8)) - global_position).angle()
	line_2d.set_point_position(1, target_local)

func _on_timer_timeout() -> void:
	animation_player.play("end_vfx")
	await animation_player.animation_finished
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "line_start":
		animation_player.play("line_vfx")
