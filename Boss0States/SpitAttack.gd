extends State

var can_transition: bool = false

func enter():
	super.enter()
	#owner.spit_aim.rotation = owner.spit_aim.global_position.angle_to_point(player.global_position)
	owner.spit_attack_follow_timer.start()
	if owner.direction.x > 0:
		animation_player.play("spit_attack_right")
		#await get_tree().create_timer(0.4165).timeout
		#owner.spit_aim.rotation = owner.spit_aim.global_position.angle_to_point(player.global_position)
		#await get_tree().create_timer(1.8326).timeout
		#owner.spit_attack_white.play("default")
		#owner.spit_attack_red.play("default")
		await animation_player.animation_finished
		#await animation_player.animation_finished
		if owner.spit_enrage == true:
			animation_player.play("spit_attack_enrage_right")
			#await get_tree().create_timer(1.8326).timeout
			#owner.spit_attack_white_enrage.play("default")
			#owner.spit_attack_red_enrage.play("default")
			await animation_player.animation_finished
	else:
		animation_player.play("spit_attack_left")
		#await get_tree().create_timer(0.4165).timeout
		#owner.spit_aim.rotation = owner.spit_aim.global_position.angle_to_point(player.global_position)
		#await get_tree().create_timer(1.8326).timeout
		#owner.spit_attack_white.play("default")
		#owner.spit_attack_red.play("default")
		await animation_player.animation_finished
		#await animation_player.animation_finished
		if owner.spit_enrage == true:
			animation_player.play("spit_attack_enrage_left")
			#await get_tree().create_timer(1.8326).timeout
			#owner.spit_attack_white_enrage.play("default")
			#owner.spit_attack_red_enrage.play("default")
			await animation_player.animation_finished
		
	owner.spit_count += 1
	#Put here spit2collision for enraged spit
	
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.spit_count % 2 == 0:
			get_parent().change_state("MoveToCenter")
		else:
			get_parent().change_state("Follow")
		
