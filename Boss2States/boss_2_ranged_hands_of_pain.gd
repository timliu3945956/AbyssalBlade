extends State

var direction : Vector2
var can_transition = false

var pain_counter = 0

func enter():
	super.enter()
	animation_player.play("idle_left")
	await get_tree().create_timer(8).timeout
	can_transition = true
	
func transition():
	if can_transition:
		print(pain_counter)
		can_transition = false
		if pain_counter == 0:
			pain_counter += 1
			get_parent().change_state("RangedSpecial")
		elif pain_counter == 1:
			pain_counter += 1
			get_parent().change_state("MorphOut")
#
#func _on_player_detection_body_entered(_body: Node2D) -> void:
	##animation_player.play("wake")
	##await animation_player.animation_finished
	##await get_tree().create_timer(0.5).timeout
	#player_entered = true
	
