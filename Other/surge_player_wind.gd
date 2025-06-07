extends Node2D

@onready var surge_wind_up_down: AnimatedSprite2D = $SurgeWindUpDown
@onready var surge_wind_right: AnimatedSprite2D = $SurgeWindRight
@onready var surge_wind_left: AnimatedSprite2D = $SurgeWindLeft

var attack_type: String
var pick_random_pattern = randi_range(1, 2)
var player: CharacterBody2D

func _ready():
	global_position = player.global_position
	randomize()
	match attack_type:
		"up":
			self.z_as_relative = false
			surge_wind_up_down.z_index = 2
			if pick_random_pattern == 1:
				surge_wind_up_down.play("updown1")
			else:
				surge_wind_up_down.play("updown2")
		"down":
			if pick_random_pattern == 1:
				surge_wind_up_down.play("updown1")
			else:
				surge_wind_up_down.play("updown2")
		"right":
			if pick_random_pattern == 1:
				surge_wind_right.play("right1")
			else:
				surge_wind_right.play("right2")
		"left":
			if pick_random_pattern == 1:
				surge_wind_left.play("left1")
			else:
				surge_wind_left.play("left2")


func _on_surge_wind_up_down_animation_finished() -> void:
	queue_free()


func _on_surge_wind_right_animation_finished() -> void:
	queue_free()


func _on_surge_wind_left_animation_finished() -> void:
	queue_free()
