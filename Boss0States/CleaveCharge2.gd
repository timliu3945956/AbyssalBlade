extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	if owner.timeline >= 6:
		owner.boss_charge_animation.play("initial_cleave_2")
	else:
		owner.boss_charge_animation.play("initial_cleave")
	match owner.pick_ns_ew:
		1:
			owner.boss_room_animation.play("cleave_ns_telegraph")
			if owner.timeline >= 6:
				await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
				owner.boss_room_animation_2.play("cleave_ew_telegraph")
				
				await TimeWait.wait_sec(1.0003)#await get_tree().create_timer(1.0003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving bottom")
				
				owner.boss_room_animation.play("cleave_ns_attack")
				#await owner.boss_room_animation.animation_finished
				await TimeWait.wait_sec(1.0005)#await get_tree().create_timer(1.0005).timeout
				
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				#await owner.boss_room_animation.animation_finished
				#owner.boss_room_animation.play("cleave_ns_attack")
				#await owner.boss_room_animation.animation_finished
				owner.boss_room_animation.play("cleave_ew_attack")
				await owner.boss_room_animation.animation_finished
			else:
				await TimeWait.wait_sec(2.5003)#await get_tree().create_timer(2.5003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				owner.boss_room_animation.play("cleave_ns_attack")
				await owner.boss_room_animation.animation_finished
		2:
			owner.boss_room_animation.play("cleave_ew_telegraph")
			if owner.timeline >= 6:
				await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
				owner.boss_room_animation_2.play("cleave_ns_telegraph")
				
				await TimeWait.wait_sec(1.0003)#await get_tree().create_timer(1.0003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving bottom")
				
				owner.boss_room_animation.play("cleave_ew_attack")
				#await owner.boss_room_animation.animation_finished
				await TimeWait.wait_sec(1.0005)#await get_tree().create_timer(1.0005).timeout
				
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				#await owner.boss_room_animation.animation_finished
				#owner.boss_room_animation.play("cleave_ew_attack")
				#await owner.boss_room_animation.animation_finished
				owner.boss_room_animation.play("cleave_ns_attack")
				await owner.boss_room_animation.animation_finished
			else:
				await TimeWait.wait_sec(2.5003)#await get_tree().create_timer(2.5003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				owner.boss_room_animation.play("cleave_ew_attack")
				await owner.boss_room_animation.animation_finished
				
	await TimeWait.wait_sec(0.75)#await get_tree().create_timer(0.75).timeout
	#owner.boss_charge_animation.play("charge_cleave_2") #Charge boss meter
	#owner.tether_animation_player.play("tether_right")
	#owner.boss_clone_animation.play("clone_right")
	#await owner.tether_animation_player.animation_finished
	
	can_transition = true
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("WalkRight")
