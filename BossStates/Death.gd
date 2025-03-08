extends State


func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	GlobalCount.boss_defeated = true
	GlobalCount.timer_active = false
	
	#owner.boss_room_animation.stop()
	#owner.top_bottom_animation_player.stop()
	#owner.in_out_animation_player.stop()
	#animation_player.stop()
	if Global.player_data.first_play_2 == true:
		Global.player_data.first_play_2 = false
		Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()
	owner.boss_killed.boss_slain()
