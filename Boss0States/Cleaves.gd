extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	print(owner.pick_top_bottom)
	if owner.timeline >= 6:
		owner.boss_charge_animation.play("initial_cleave_2")
	else:
		owner.boss_charge_animation.play("initial_cleave")
	match owner.pick_top_bottom:
		1:
			owner.boss_room_animation.play("cleave_vertical_telegraph")
			if owner.timeline >= 6:
				await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
				owner.boss_room_animation_2.play("cleave_horizontal_telegraph")
				
				await TimeWait.wait_sec(1.0003)#await get_tree().create_timer(1.0003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving top")
				#await get_tree().create_timer(0.4998).timeout
				owner.boss_room_animation.play("cleave_vertical_attack")
				#await owner.boss_room_animation.animation_finished
				await TimeWait.wait_sec(1.0005)#await get_tree().create_timer(1.0005).timeout

				
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				
				owner.boss_room_animation.play("cleave_horizontal_attack")
				await owner.boss_room_animation.animation_finished
			else:
				await TimeWait.wait_sec(2.5003)#await get_tree().create_timer(2.5003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving top")
				owner.boss_room_animation.play("cleave_vertical_attack")

				await owner.boss_room_animation.animation_finished
		2:
			print("cleaving bottom telegraph")
			owner.boss_room_animation.play("cleave_horizontal_telegraph")
			if owner.timeline >= 6:
				#changed to 2 seconds timeout
				await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
				owner.boss_room_animation_2.play("cleave_vertical_telegraph")

				await TimeWait.wait_sec(1.0003)#await get_tree().create_timer(1.0003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving bottom")
				#await get_tree().create_timer(0.4998).timeout
				owner.boss_room_animation.play("cleave_horizontal_attack")
				#await owner.boss_room_animation.animation_finished
				await TimeWait.wait_sec(1.0005)#await get_tree().create_timer(1.0005).timeout
				
				animation_player.play("buff_attack")
				await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
				
				owner.boss_room_animation.play("cleave_vertical_attack")
				await owner.boss_room_animation.animation_finished
			else:
				await TimeWait.wait_sec(2.5003)#await get_tree().create_timer(2.5003).timeout
				animation_player.play("buff_attack")
				await owner.boss_room_animation.animation_finished
				print("Currently cleaving bottom")
				owner.boss_room_animation.play("cleave_horizontal_attack")
				await owner.boss_room_animation.animation_finished
	
	
	await TimeWait.wait_sec(0.75)#await get_tree().create_timer(0.75).timeout
	#owner.boss_charge_animation.play("charge_cleave")
	#owner.tether_animation_player.play("tether_left")
	#owner.boss_clone_animation.play("clone_left")
	#await owner.tether_animation_player.animation_finished
	owner.boss_clone_animation_2.play("idle")
	can_transition = true
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("WalkLeft")
