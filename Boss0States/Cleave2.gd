extends State

var can_transition: bool = false
var phase_vfx = preload("res://Other/boss_0_phase_vfx.tscn")

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("clone_attack")
	match owner.pick_cleave:
		1:
			owner.boss_clone_animation.play("clone_end_particles_right")
			owner.tether_animation_player.play("tether_right")
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
				await animation_player.animation_finished
			await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
			if owner.spit_enrage == false:
				owner.boss_charge_animation.play("enrage_cast")
				await owner.boss_charge_animation.animation_finished
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				owner.enrage_background.play("background_change")
				owner.phase_2_sound()
				owner.camera_shake_phase_2()
				owner.enrage_fire.emitting = true
				owner.enrage_fire_pop.emitting = true
				await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
		2:
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
				await animation_player.animation_finished
			await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
			if owner.spit_enrage == false:
				owner.boss_charge_animation.play("enrage_cast")
				await owner.boss_charge_animation.animation_finished
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				owner.enrage_background.play("background_change")
				owner.phase_2_sound()
				owner.camera_shake_phase_2()
				owner.enrage_fire.emitting = true
				owner.enrage_fire_pop.emitting = true
				await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.pick_cleave = randi_range(1, 2)
	owner.pick_ns_ew = randi_range(1, 2)
	owner.pick_top_bottom = randi_range(1, 2)
	
	owner.spit_enrage = true
	can_transition = true
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
		
func start_phase_change_vfx():
	var vfx = phase_vfx.instantiate()
	vfx.position = Vector2(0, -15)
	add_child(vfx)
		
