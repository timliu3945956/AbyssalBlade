extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("clone_attack")
	match owner.pick_cleave:
		1:
			owner.boss_clone_animation.play("clone_end_particles_left")
			owner.tether_animation_player.play("tether_left")
			await TimeWait.wait_sec(2.5)#await get_tree().create_timer(2.5).timeout
			animation_player.play("buff_attack")
	
			await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
			match owner.pick_top_bottom: 
				1:
					owner.boss_room_animation.play("cleave_vertical_attack")
				2:
					owner.boss_room_animation.play("cleave_horizontal_attack")
			
			if owner.spit_enrage == true:
				await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
				match owner.pick_top_bottom:
					1:
						owner.boss_room_animation.play("cleave_horizontal_attack")
					2:
						owner.boss_room_animation.play("cleave_vertical_attack")
		2:
			owner.boss_clone_animation.play("clone_end_particles_right")
			owner.tether_animation_player.play("tether_right")
			#await owner.tether_animation_player.animation_finished
			await TimeWait.wait_sec(2.5)#await get_tree().create_timer(2.5).timeout
			animation_player.play("buff_attack")
			
			await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
			match owner.pick_ns_ew: 
				1:
					owner.boss_room_animation.play("cleave_ns_attack")
				2:
					owner.boss_room_animation.play("cleave_ew_attack")
			
			if owner.spit_enrage == true:
				await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
				
				animation_player.play("buff_attack")
				
				await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
				match owner.pick_ns_ew: 
					1:
						owner.boss_room_animation.play("cleave_ew_attack")
					2:
						owner.boss_room_animation.play("cleave_ns_attack")
						
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
		
