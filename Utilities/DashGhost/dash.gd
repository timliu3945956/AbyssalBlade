extends Node2D

@onready var duration_timer: Timer = $DurationTimer

var ghost_scene = preload("res://Utilities/DashGhost/DashGhost.tscn")
var sprite

# Called when the node enters the scene tree for the first time.
func start_dash(sprite, duration):
	self.sprite = sprite
	
	duration_timer.wait_time = duration
	duration_timer.start()
	
	instance_ghost()
	

func instance_ghost():
	var ghost = ghost_scene.instantiate()
	add_child(ghost)
	
	ghost.position = position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
