extends Node2D

@onready var meteor_timer: Timer = $MeteorTimer

@onready var player = get_parent().find_child("Player")
var Meteor = preload("res://Other/MeteorMech.tscn")
var meteor_drop = Meteor.instantiate()

var squares = [
	Vector2(-112.5, -112.5),
	Vector2(-37.5, -112.5),
	Vector2(37.5, -112.5),
	Vector2(112.5, -112.5),
	Vector2(-112.5, -37.5),
	Vector2(-37.5, -37.5),
	Vector2(37.5, -37.5),
	Vector2(112.5, -37.5),
	Vector2(-112.5, 37.5),
	Vector2(-37.5, 37.5),
	Vector2(37.5, 37.5),
	Vector2(112.5, 37.5),
	Vector2(-112.5, 112.5),
	Vector2(-37.5, 112.5),
	Vector2(37.5, 112.5),
	Vector2(112.5, 112.5)
]

func closest_square_position(player_pos: Vector2):
	var closest_pos = squares[0]
	var closest_dist = player_pos.distance_to(closest_pos)
	
	for square_pos in squares:
		var dist = player_pos.distance_to(square_pos)
		if dist < closest_dist:
			closest_dist = dist
			closest_pos = square_pos
			
	spawn_meteor(closest_pos)

func spawn_meteor(target_position: Vector2):
	if is_instance_valid(player):
		meteor_drop = Meteor.instantiate()
		meteor_drop.position = target_position
		add_child(meteor_drop)
