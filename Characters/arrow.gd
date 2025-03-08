extends CharacterBody2D

var direction : Vector2
var move_speed = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * move_speed
	move_and_slide()
