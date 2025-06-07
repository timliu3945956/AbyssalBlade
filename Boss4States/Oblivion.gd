extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	owner.state_machine.travel("Idle")
	owner.attack_meter_animation.play("oblivion")
	owner.state_machine.travel("swordraise_start")
	owner.constant_fire_audio.play()
	#owner.boss_room.spawn_shield()
	owner.oblivion_ball_animation.play("oblivion")
		
	await get_tree().create_timer(4).timeout
	#owner.oblivion_audio.play()
	#await get_tree().create_timer(0.2).timeout
	#if is_instance_valid(owner.boss_room.spawn_clone):
		#owner.hope_safe_audio.play()
	#await get_tree().create_timer(0.3).timeout
	owner.state_machine.travel("swordraise_finish")
	await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(0.2).timeout
	owner.oblivion_audio.play()
	if is_instance_valid(owner.boss_room.spawn_clone):
		owner.hope_safe_audio.play()
	await get_tree().create_timer(0.0333).timeout
	owner.boss_room.spawn_shield()
	await owner.attack_meter_animation.animation_finished
	
	owner.clone_signal()
	owner.boss_room.check_clone_alive()
	
	await get_tree().create_timer(2).timeout
	owner.oblivion_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.oblivion_count == 1:
			get_parent().change_state("Debuff")
		elif owner.oblivion_count == 2:
			get_parent().change_state("FatalEnd")
		elif owner.oblivion_count == 3:
			get_parent().change_state("Enrage")
