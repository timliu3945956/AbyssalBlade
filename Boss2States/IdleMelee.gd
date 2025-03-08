extends State

@onready var collision: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"

var direction : Vector2

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)

func enter():
	super.enter()
	animation_player.play("idle_right")
	
func transition():
	if player_entered:
		return
		#GlobalCount.timer_active = true
		#GlobalCount.can_pause = false
		#get_parent().change_state("Mechanic1")

func _on_player_detection_body_entered(_body: Node2D) -> void:
	player_entered = true
	
