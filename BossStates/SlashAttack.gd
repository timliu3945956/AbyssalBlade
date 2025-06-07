extends State

@onready var attack_fire: AnimatedSprite2D = $"../../NormalAttack/AttackFire"
@onready var chain_aim: Marker2D = $"../../ChainAim"

var can_transition: bool = false

func enter():
	super.enter()
	if owner.direction.x > 0:
		animation_player.play("slash_right")
		owner.timer.start()
	else:
		animation_player.play("slash_left")
		owner.timer.start()
		
	#await get_tree().create_timer(2.2491).timeout
	#attack_fire.play("fire")
	owner.slash_count += 1
	await get_tree().create_timer(2.2491).timeout
	attack_fire.play("fire")
	await animation_player.animation_finished
	
	#if owner.timeline >= 11 and owner.slash_count % 2 != 0:
		#get_parent().change_state("Follow")
	if owner.timeline >= 11 and owner.slash_count % 2 == 0:
		#if owner.direction.x > 0:
			#animation_player.play("slash_right")
			#owner.timer.start()
		#else:
			#animation_player.play("slash_left")
			#owner.timer.start()
			#
		#await get_tree().create_timer(2.2491).timeout
		#attack_fire.play("fire")
		#await animation_player.animation_finished
		
		
		#if owner.direction.x > 0:
			#animation_player.play("chain_chargeup_right")
			#owner.chain_attack_collision_timer.start()
			#owner.chain_attack_follow_timer.start()
		#else:
			#animation_player.play("chain_chargeup_left")
			#owner.chain_attack_collision_timer.start()
			#owner.chain_attack_follow_timer.start()
		#await animation_player.animation_finished
		if owner.direction.x > 0:
			#animation_player.play("chain_attack_right")
			#await animation_player.animation_finished
			# in out top down attack
			var choose_in_out = randi_range(1, 2)
			animation_player.play("idle_right")
			match choose_in_out:
				1:
					owner.in_out_animation_player.play("attack_in")
				2:
					owner.in_out_animation_player.play("attack_out")
			await get_tree().create_timer(1.8326).timeout
			match owner.choose_top_down:
					1:
						owner.boss_room_animation.play("top_attack")
					2:
						owner.boss_room_animation.play("bottom_attack")
			await get_tree().create_timer(0.3332).timeout
			animation_player.play("alternate_slam")
			
			await animation_player.animation_finished
			animation_player.play("idle_right")
			owner.top_down_charge_count += 1
		else:
			#animation_player.play("chain_attack_left")
			#await animation_player.animation_finished
			var choose_in_out = randi_range(1, 2)
			animation_player.play("idle_right")
			match choose_in_out:
				1:
					owner.in_out_animation_player.play("attack_in")
				2:
					owner.in_out_animation_player.play("attack_out")
			await get_tree().create_timer(1.8326).timeout
			match owner.choose_top_down:
					1:
						owner.boss_room_animation.play("top_attack")
					2:
						owner.boss_room_animation.play("bottom_attack")
			await get_tree().create_timer(0.3332).timeout
			#owner.boss_room_animation.stop()
			animation_player.play("alternate_slam")
			
			await animation_player.animation_finished
			animation_player.play("idle_left")
			owner.top_down_charge_count += 1
		
		if owner.top_down_charge_count % 2 == 0 and owner.enraged:
			#await get_tree().create_timer(1).timeout
			animation_player.play("idle_right")
			#player.beam_circle_meteor()
			owner.boss_room_animation.play("meteor")
			await get_tree().create_timer(2.6668).timeout
			animation_player.play("alternate_slam")
			await get_tree().create_timer(0.3332).timeout
			#owner.beam_circle()
			
			owner.meteor.closest_square_position(player.position)
			await get_tree().create_timer(1.4004).timeout
			animation_player.play("idle_right")
			await get_tree().create_timer(0.9996).timeout
			owner.timeline += 1
	#print(owner.slash_count)
		
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.timeline >= 11 and owner.slash_count % 2 != 0:
			#owner.timeline += 1
			owner.timeline = owner.timeline
		elif owner.timeline < 11 and owner.slash_count % 2 == 0:
			owner.timeline += 1
		print("this is timeline number: ", owner.timeline)
		get_parent().change_state("Transition")
		
		
