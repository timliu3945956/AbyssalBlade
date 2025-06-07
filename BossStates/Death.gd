extends State


func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	GlobalCount.boss_defeated = true
	GlobalCount.timer_active = false
	owner.player.hurtbox.set_deferred("disabled", true)
	owner.boss_room.static_outer_arena.set_deferred("disabled", false)
	
	if Global.player_data_slots[Global.current_slot_index].first_play_2 == true:
		player.set_process(false)
		#Global.player_data_slots[Global.current_slot_index].first_play_2 = false
		#Global.save_data(Global.current_slot_index)
	var achievement = Steam.getAchievement("DefeatAnger")
	if achievement.ret && !achievement.achieved:
		Steam.setAchievement("DefeatAnger")
		Steam.storeStats()
	animation_player.play("death")
	await animation_player.animation_finished
	
	owner.enrage_background.play("background_end")
	queue_free()
	owner.boss_killed.boss_slain()
	AudioPlayer.fade_out_music(5)
