extends Sprite2D

var time := 0.0
@export var power := 0.0
@export var speed := 1.0
@export var min_scale := 0.5
@export var max_scale := 1.0


func _process(delta):
	time = wrapf(time+delta*speed, -PI, PI)
	scale = Vector2(sin(time) * power, scale.y)
