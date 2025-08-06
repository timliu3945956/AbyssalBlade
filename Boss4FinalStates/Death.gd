extends State


func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	GlobalCount.boss_defeated = true
	GlobalCount.timer_active = false
	owner.player.hurtbox.set_deferred("disabled", true)
	owner.boss_room.static_outer_arena.set_deferred("disabled", false)
	#owner.boss_room_animation.stop()
	#owner.top_bottom_animation_player.stop()
	#owner.in_out_animation_player.stop()
	#animation_player.stop()
	#if Global.player_data_slots[Global.current_slot_index].first_play_5 == true:
		#Global.player_data_slots[Global.current_slot_index].first_play_5 = false
		#Global.save_data(Global.current_slot_index)
		
	var achievement = Steam.getAchievement("DefeatGrief")
	if achievement.ret && !achievement.achieved:
		Steam.setAchievement("DefeatGrief")
		Steam.storeStats()
		
	if GlobalCount.abyss_mode:
		var achievementAbyssMode = Steam.getAchievement("DefeatGriefAbyss")
		if achievementAbyssMode.ret && !achievementAbyssMode.achieved:
			Steam.setAchievement("DefeatGriefAbyss")
			Steam.storeStats()
	SteamGlobal._check_completionist()
	
	animation_player.play("death")
	await owner.boss_death_anim.animation_finished
	owner.enrage_animation.play("background_end")
	owner.boss_room.foreground_arena.queue_free()
	print("boss_slain_function playing")
	
	AudioPlayer.fade_out_music(3)
	
	if Global.player_data_slots[Global.current_slot_index].deaths == 0:
		var achieve_deathless = Steam.getAchievement("Deathless")
		if achieve_deathless.ret && !achieve_deathless.achieved:
			Steam.setAchievement("Deathless")
			Steam.storeStats()
		SteamGlobal._check_completionist()
	
	if Global.player_data_slots[Global.current_slot_index].first_play_6:
		owner.boss_killed.boss_slain()
		owner.player.untransform_audio.volume_db = -80
		await get_tree().create_timer(2).timeout
		owner.cutscene_player.play("repeat_cutscene")
		await owner.cutscene_player.animation_finished
		var achievement_true_ending = Steam.getAchievement("TrueEnding")
		if achievement_true_ending.ret && !achievement_true_ending.achieved:
			Steam.setAchievement("TrueEnding")
			Steam.storeStats()
		#if Global.player_data_slots[Global.current_slot_index].deaths == 0:
			#var achieve_deathless = Steam.getAchievement("Deathless")
			#if achieve_deathless.ret && !achieve_deathless.achieved:
				#Steam.setAchievement("Deathless")
				#Steam.storeStats()
		SteamGlobal._check_completionist()
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/credits-scene/credits.tscn")
	else:
		owner.boss_killed.boss_slain()
		await get_tree().create_timer(1).timeout
		owner.sprite.queue_free()
		owner.sprite_shadow.queue_free()
		owner.cutscene_player.play("repeat_boss_death")
	#await animation_player.animation_finished
	
	#owner.sprite.queue_free()
	
	#queue_free()
	
	
		
