extends State

@onready var collision: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"

var direction : Vector2

var player_entered: bool = false:
	set(value):
		player_entered = value
		#collision.set_deferred("disabled", value)

func enter():
	super.enter()
	animation_player.play("idle_left")
	
#func transition():
	#if player_entered:
		#GlobalCount.timer_active = true
		#GlobalCount.can_pause = false
		#get_parent().change_state("WalkLeftRight")
#
#func _on_player_detection_body_entered(_body: Node2D) -> void:
	##animation_player.play("wake")
	##await animation_player.animation_finished
	##await get_tree().create_timer(0.5).timeout
	#player_entered = true
	
