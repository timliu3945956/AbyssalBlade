extends State

var can_transition: bool = false
var pick_cleave = randi_range(1, 2)

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	print(owner.pick_top_bottom)
	print(owner.pick_ns_ew)
	owner.boss_charge_animation.play("clone_attack")
	
	match owner.pick_cleave:
		1:
			owner.boss_clone_animation.play("clone_end_particles_left")
			owner.tether_animation_player.play("tether_left")
			#await owner.tether_animation_player.animation_finished
			await get_tree().create_timer(2.5).timeout
			match owner.pick_top_bottom: 
				1:
					owner.boss_room_animation.play("cleave_vertical_telegraph_short")
				2:
					owner.boss_room_animation.play("cleave_horizontal_telegraph_short")
			animation_player.play("buff_attack")
	
			await get_tree().create_timer(0.5).timeout
			match owner.pick_top_bottom: 
				1:
					owner.boss_room_animation.play("cleave_vertical_attack")
				2:
					owner.boss_room_animation.play("cleave_horizontal_attack")
			
		2:
			owner.boss_clone_animation.play("clone_end_particles_right")
			owner.tether_animation_player.play("tether_right")
			await owner.tether_animation_player.animation_finished
			await get_tree().create_timer(2.5).timeout
			#match owner.pick_nsew:
	#owner.boss_clone_animation.play("clone_end_particles")
	#owner.tether_animation_player.play("tether")
	#await owner.tether_animation_player.animation_finished
	#await get_tree().create_timer(2.5).timeout
	
	# Continue from here tomorrow for editing boss fight
	
	#and owner.pick_ns_ew == 1:
		#owner.boss_room_animation.play("cleave_vertical_telegraph_short")
		#owner.boss_room_animation_2.play("cleave_ns_telegraph_short")
	#elif owner.pick_top_bottom == 1 and owner.pick_ns_ew == 2:
		#owner.boss_room_animation.play("cleave_vertical_telegraph_short")
		#owner.boss_room_animation_2.play("cleave_ew_telegraph_short")
	#elif owner.pick_top_bottom == 2 and owner.pick_ns_ew == 1:
		#owner.boss_room_animation.play("cleave_horizontal_telegraph_short")
		#owner.boss_room_animation_2.play("cleave_ns_telegraph_short")
	#else:
		#owner.boss_room_animation.play("cleave_horizontal_telegraph_short")
		#owner.boss_room_animation_2.play("cleave_ew_telegraph_short")
	
	#await get_tree().create_timer(2).timeout
	#animation_player.play("buff_attack")
	#
	#await get_tree().create_timer(0.5).timeout
	if owner.pick_top_bottom == 1 and owner.pick_ns_ew == 1:
		owner.boss_room_animation.play("cleave_vertical_attack")
		owner.boss_room_animation_2.play("cleave_ns_attack")
		await owner.boss_room_animation.animation_finished
		await owner.top_bottom_attack_2.animation_finished
		if owner.timeline >= 6:
			await get_tree().create_timer(2).timeout
			animation_player.play("buff_attack")
			owner.boss_room_animation.play("cleave_horizontal_telegraph_short")
			owner.boss_room_animation_2.play("cleave_ew_telegraph_short")
			await get_tree().create_timer(0.5).timeout
			owner.boss_room_animation.play("cleave_horizontal_attack")
			owner.boss_room_animation_2.play("cleave_ew_attack")
			await owner.boss_room_animation.animation_finished
			await owner.top_bottom_attack_2.animation_finished
	elif owner.pick_top_bottom == 1 and owner.pick_ns_ew == 2:
		owner.boss_room_animation.play("cleave_vertical_attack")
		owner.boss_room_animation_2.play("cleave_ew_attack")
		await owner.boss_room_animation.animation_finished
		await owner.top_bottom_attack_2.animation_finished
		if owner.timeline >= 6:
			await get_tree().create_timer(2).timeout
			animation_player.play("buff_attack")
			owner.boss_room_animation.play("cleave_horizontal_telegraph_short")
			owner.boss_room_animation_2.play("cleave_ns_telegraph_short")
			await get_tree().create_timer(0.5).timeout
			owner.boss_room_animation.play("cleave_horizontal_attack")
			owner.boss_room_animation_2.play("cleave_ns_attack")
			await owner.boss_room_animation.animation_finished
			await owner.top_bottom_attack_2.animation_finished
	elif owner.pick_top_bottom == 2 and owner.pick_ns_ew == 1:
		owner.boss_room_animation.play("cleave_horizontal_attack")
		owner.boss_room_animation_2.play("cleave_ns_attack")
		await owner.boss_room_animation.animation_finished
		await owner.top_bottom_attack_2.animation_finished
		if owner.timeline >= 6:
			await get_tree().create_timer(2).timeout
			animation_player.play("buff_attack")
			owner.boss_room_animation.play("cleave_vertical_telegraph_short")
			owner.boss_room_animation_2.play("cleave_ew_telegraph_short")
			await get_tree().create_timer(0.5).timeout
			owner.boss_room_animation.play("cleave_vertical_attack")
			owner.boss_room_animation_2.play("cleave_ew_attack")
			await owner.boss_room_animation.animation_finished
			await owner.top_bottom_attack_2.animation_finished
	else:
		owner.boss_room_animation.play("cleave_horizontal_attack")
		owner.boss_room_animation_2.play("cleave_ew_attack")
		await owner.boss_room_animation.animation_finished
		await owner.top_bottom_attack_2.animation_finished
		if owner.timeline >= 6:
			await get_tree().create_timer(2).timeout
			animation_player.play("buff_attack")
			owner.boss_room_animation.play("cleave_vertical_telegraph_short")
			owner.boss_room_animation_2.play("cleave_ns_telegraph_short")
			await get_tree().create_timer(0.5).timeout
			owner.boss_room_animation.play("cleave_vertical_attack")
			owner.boss_room_animation_2.play("cleave_ns_attack")
			await owner.boss_room_animation.animation_finished
			await owner.top_bottom_attack_2.animation_finished
	
	#owner.boss_clone_animation.play("clones_end")
	await get_tree().create_timer(0.5).timeout
	#owner.tether_animation_player.play("tether_right")
	#await owner.boss_clone_animation.animation_finished
	can_transition = true
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
		
