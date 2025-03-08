extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	# Add vfx here
	print("This is ranged in DarknessBalance")
	if owner.jump_position_count == 1:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	await get_tree().create_timer(10).timeout
	
	owner.morph_animation.play("flash")
	await get_tree().create_timer(2).timeout
	
	#owner.paused = false
	
	owner.balance_counter += 1
	print("ranged_balance_count: ", owner.balance_counter)
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.balance_counter == 1:
			get_parent().change_state("AutoAttack")
		else:
			print(owner.balance_counter)
			get_parent().change_state("MorphOut")
