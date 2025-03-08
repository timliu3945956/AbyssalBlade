extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.morph_animation.play("morph_in")
	animation_player.play("idle_right")
	
	await get_tree().create_timer(4).timeout #1 second added
	
	#owner.paused = false
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("AutoAttack")
