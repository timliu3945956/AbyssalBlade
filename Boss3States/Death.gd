extends State


func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	GlobalCount.boss_defeated = true
	GlobalCount.timer_active = false
	owner.player.hurtbox.set_deferred("disabled", true)
	owner.boss_room.static_outer_arena.set_deferred("disabled", false)
	
	if Global.player_data_slots[Global.current_slot_index].first_play_4 == true:
		player.set_process(false)
		
	var achievement = Steam.getAchievement("DefeatDepression")
	if achievement.ret && !achievement.achieved:
		Steam.setAchievement("DefeatDepression")
		Steam.storeStats()
		
	if GlobalCount.abyss_mode:
		var achievementAbyssMode = Steam.getAchievement("DefeatDepressionAbyss")
		if achievementAbyssMode.ret && !achievementAbyssMode.achieved:
			Steam.setAchievement("DefeatDepressionAbyss")
			Steam.storeStats()
	SteamGlobal._check_completionist()
	
	animation_player.play("death")
	owner.boss_room.ground_aura_end()
	await animation_player.animation_finished
	owner.enrage_background.play("background_end")
	queue_free()
	owner.boss_killed.boss_slain()
	AudioPlayer.fade_out_music(3)
		
