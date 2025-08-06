extends State

var can_transition: bool = false
var alternate_count = 0
var choose_alternate = randi_range(1, 2)
var choose_in_out = randi_range(1, 2)

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	owner.choose_top_down = randi_range(1, 2)
	owner.boss_room_animation.play("chargeup_alternate")
	animation_player.play("idle_right")
	await owner.boss_room_animation.animation_finished
	
	var smoke_tween = get_tree().create_tween()
	smoke_tween.tween_property(owner.alternate_smoke, "modulate:a", 1, 0.5)
	
	match choose_alternate:
		1:
			owner.smoke_alternate_1.play("smoke")
			owner.smoke_alternate_2.play("smoke")
			owner.boss_room_animation.play("alternate")
		2:
			owner.smoke_alternate_opposite_1.play("smoke")
			owner.smoke_alternate_opposite_2.play("smoke")
			owner.boss_room_animation.play("alternate_opposite")
	#animation_player.play("charge_into")
	#await animation_player.animation_finished
	#animation_player.play("charge")
	animation_player.play("combination_alternate")
	#await get_tree().create_timer(2.1658).timeout
	
	while alternate_count < 8 and owner.boss_death == false:
		if alternate_count == 3 or alternate_count == 6:
			await TimeWait.wait_sec(0.4998)#await get_tree().create_timer(0.4998).timeout
			match choose_in_out:
				1:
					owner.in_out_animation_player.play("attack_in")
				2:
					owner.in_out_animation_player.play("attack_out")
			await TimeWait.wait_sec(1.8326)#await get_tree().create_timer(1.8326).timeout #1.8326 total await time
			#match owner.choose_top_down:
				#1:
					#owner.top_bottom_animation_player.play("top_attack")
				#2:
					#owner.top_bottom_animation_player.play("bottom_attack")
			choose_in_out = randi_range(1, 2)
			owner.choose_top_down = randi_range(1, 2)
			await TimeWait.wait_sec(0.6664)#await get_tree().create_timer(0.6664).timeout
		#if alternate_count != 3 and alternate_count != 6:
			#if alternate_count == 0:
				#await get_tree().create_timer(3-0.1666).timeout
			#else:
				#await get_tree().create_timer(2.9988).timeout
		if alternate_count != 7 and alternate_count != 6:
			#if alternate_count == 0:
			
			await TimeWait.wait_sec(2.9988)#await get_tree().create_timer(2.9988).timeout
				#await get_tree().create_timer(2.9988-0.1666).timeout
			#else:
			
			print(alternate_count)
		alternate_count += 1
	if owner.boss_death == false:
		var smoke_finish_tween = get_tree().create_tween()
		smoke_finish_tween.tween_property(owner.alternate_smoke, "modulate:a", 0, 0.5)
		
		await TimeWait.wait_sec(0.9996)#await get_tree().create_timer(0.9996).timeout
		await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
		
		can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
