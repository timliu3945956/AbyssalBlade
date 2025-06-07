extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.state_machine.travel("swordraise_start")
	owner.enrage_sword_spawn()
	await get_tree().create_timer(0.5).timeout
	owner.attack_meter_animation.play("enrage")
	
	await get_tree().create_timer(3).timeout
	#owner.state_machine.travel("enrage_repeat_end")
	await get_tree().create_timer(3).timeout
	#owner.state_machine.travel("enrage_repeat_end 2")
	#owner.sword_animation_player.play("sword_grow_particle")
	
	#owner.state_machine.travel("swordraise_finish")
	await owner.attack_meter_animation.animation_finished
	
	#if owner.health_amount >= (owner.healthbar.max_value / 2):
		#owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
		#owner.state_machine.travel("downattack_stand")
		#owner.spawn_enrage_attack()
	#else:
	if Global.player_data_slots[Global.current_slot_index].first_play_5 == true:
		Global.player_data_slots[Global.current_slot_index].first_play_5 = false
		Global.save_data(Global.current_slot_index)
	AudioPlayer.stop_music()
	GlobalCount.stage_select_pause = true
	GlobalCount.in_subtree_menu = true
	GlobalCount.timer_active = false
	owner.enrage_animation.play("flash_screen")
	owner.cutscene_player.play("cutscene_between_phase")
	GlobalCount.boss_4_final_health = owner.health_amount
	GlobalCount.boss_4_final_player_mana = player.mana
	await owner.cutscene_player.animation_finished
	owner.cutscene_player.play("idle_cutscene")
	
#func transition():
	#if can_transition:
		#can_transition = false
