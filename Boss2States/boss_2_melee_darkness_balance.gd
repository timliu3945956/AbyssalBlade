extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	if owner.jump_position_count == 1:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	print("This is melee in DarknessBalance")
	owner.attack_meter_animation.play("darkness_balance")
	
	owner.darkness_balance_vfx_spawn()
	owner.boss_2_ranged.darkness_balance_vfx_spawn()
	owner.vfx_timer.start()
	owner.boss_2_ranged.vfx_timer.start()
	
	owner.pain_line.start()
	await owner.attack_meter_animation.animation_finished
	
	owner.hands_of_pain()
	owner.morph_animation.play("flash")
	
	owner.vfx_timer.stop()
	owner.boss_2_ranged.vfx_timer.stop()
	
	await get_tree().create_timer(2).timeout
	
	#owner.paused = false
	
	owner.balance_counter += 1
	print("melee_balance_count: ", owner.balance_counter)
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.balance_counter == 1:
			get_parent().change_state("AutoAttack")
		else:
			print(owner.balance_counter)
			get_parent().change_state("MorphOut")
