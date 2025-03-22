extends CanvasLayer

@onready var time: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer1/Time
@onready var best_time: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer3/BestTime
@onready var attempts: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer2/Attempts
@onready var clear_count: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer4/ClearCount
@onready var attempts_container: HBoxContainer = $Panel2/MarginContainer/VBoxContainer/HBoxContainer2
@onready var clear_count_container: HBoxContainer = $Panel2/MarginContainer/VBoxContainer/HBoxContainer4

func _ready() -> void:
	self.hide()
	time.hide()
	best_time.hide()
	attempts.hide()
	attempts_container.hide()
	clear_count_container.hide()

func boss_slain():
	get_tree().paused = true
	
	self.show()
	
	await get_tree().create_timer(0.5).timeout
	format_time(GlobalCount.elapsed_time)
	
	match get_tree().get_current_scene().name:
		"BossRoom0":
			Global.player_data.clear_count_1 += 1
			if Global.player_data.clear_count_1 == 1:
				Global.player_data.first_clear_time_1 = GlobalCount.elapsed_time
				
			if Global.player_data.best_time_boss_1 == 0.0 or Global.player_data.best_time_boss_1 > GlobalCount.elapsed_time:
				Global.player_data.best_time_boss_1 = GlobalCount.elapsed_time
				Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
				print(Global.player_data.best_time_boss_1)
				#best_record = Global.player_data.best_time_boss_1
		"BossRoom1":
			Global.player_data.clear_count_2 += 1
			if Global.player_data.clear_count_2 == 1:
				Global.player_data.first_clear_time_2 = GlobalCount.elapsed_time
				
			if Global.player_data.best_time_boss_2 == 0.0 or Global.player_data.best_time_boss_2 > GlobalCount.elapsed_time:
				Global.player_data.best_time_boss_2 = GlobalCount.elapsed_time
				Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
				print(Global.player_data.best_time_boss_2)
				#best_record = Global.player_data.best_time_boss_2
		"BossRoom2":
			Global.player_data.clear_count_3 += 1
			if Global.player_data.clear_count_3 == 1:
				Global.player_data.first_clear_time_3 = GlobalCount.elapsed_time
				
			if Global.player_data.best_time_boss_3 == 0.0 or Global.player_data.best_time_boss_3 > GlobalCount.elapsed_time:
				Global.player_data.best_time_boss_3 = GlobalCount.elapsed_time
				Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
				print(Global.player_data.best_time_boss_3)
				#best_record = Global.player_data.best_time_boss_3
		"BossRoom3":
			Global.player_data.clear_count_4 += 1
			if Global.player_data.clear_count_4 == 1:
				Global.player_data.first_clear_time_4 = GlobalCount.elapsed_time
				
			if Global.player_data.best_time_boss_4 == 0.0 or Global.player_data.best_time_boss_4 > GlobalCount.elapsed_time:
				Global.player_data.best_time_boss_4 = GlobalCount.elapsed_time
				Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
				print(Global.player_data.best_time_boss_4)
				#best_record = Global.player_data.best_time_boss_4
	await _label_animation(time, 0, 0.025)
	time.show()
	await _label_animation(best_time, 0, 0.025)
	best_time.show()
	#var dps_to_int = GlobalCount.dps_count / GlobalCount.elapsed_time
	# GlobalCount.dps_count
	await _label_animation(attempts, 0, 0.010)
	
	await _label_animation(clear_count, 0, 0.010)
	
func _label_animation(label: Label, value: float, duration: float):
	if label == time:
		label.text = format_time(GlobalCount.elapsed_time)
		await get_tree().create_timer(0.5).timeout
	elif label == best_time:
		match get_tree().get_current_scene().name:
			"BossRoom0":
				label.text = format_time(Global.player_data.best_time_boss_1)
				#label.text = str(Global.player_data.deaths_boss_1)
			"BossRoom1":
				label.text = format_time(Global.player_data.best_time_boss_2)
				#label.text = str(Global.player_data.deaths_boss_2)
			"BossRoom2":
				label.text = format_time(Global.player_data.best_time_boss_3)
				#label.text = str(Global.player_data.deaths_boss_3)
			"BossRoom3":
				label.text = format_time(Global.player_data.best_time_boss_4)
		
		await get_tree().create_timer(0.5).timeout
	elif label == attempts:
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data.clear_count_1 == 1:
					label.text = str(Global.player_data.attempt_count_1)
					label.show()
					attempts_container.show()
				#else:
					#attempts_container.hide()
			"BossRoom1":
				if Global.player_data.clear_count_2 == 1:
					label.text = str(Global.player_data.attempt_count_2)
					label.show()
					attempts_container.show()
				#else:
					#attempts_container.hide()
			"BossRoom2":
				if Global.player_data.clear_count_3 == 1:
					label.text = str(Global.player_data.attempt_count_3)
					label.show()
					attempts_container.show()
				#else:
					#attempts_container.hide()
			"BossRoom3":
				if Global.player_data.clear_count_4 == 1:
					label.text = str(Global.player_data.attempt_count_4)
					label.show()
					attempts_container.show()
				#else:
					#attempts_container.hide()
		#"%0.1f" % (GlobalCount.dps_count / GlobalCount.elapsed_time)
		#await get_tree().create_timer(0.5).timeout
	elif label == clear_count:
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data.clear_count_1 > 1:
					label.text = str(Global.player_data.clear_count_1)
					label.show()
					clear_count_container.show()
				#else:
					#clear_count_container.hide()
			"BossRoom1":
				if Global.player_data.clear_count_2 > 1:
					label.text = str(Global.player_data.clear_count_2)
					label.show()
					clear_count_container.show()
				#else:
					#clear_count_container.hide()
			"BossRoom2":
				if Global.player_data.clear_count_3 > 1:
					label.text = str(Global.player_data.clear_count_3)
					label.show()
					clear_count_container.show()
				#else:
					#clear_count_container.hide()
			"BossRoom3":
				if Global.player_data.clear_count_4 > 1:
					label.text = str(Global.player_data.clear_count_4)
					label.show()
					clear_count_container.show()
				#else:
					#clear_count_container.hide()
		#await get_tree().create_timer(0.5).timeout
		
func format_time(time_in_seconds):
	var minutes = int(time_in_seconds) / 60
	var seconds = int(time_in_seconds) % 60
	
	
	var milliseconds = int((time_in_seconds - int(time_in_seconds)) * 100)
	#print("milliseconds time: ", time_in_seconds - seconds)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _on_retry_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().paused = false
	
	get_tree().reload_current_scene()
	
	#GlobalCount.reset_count()
	
func _on_main_menu_pressed() -> void:
	AudioPlayer.stop()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")
	AudioPlayer.stop_music()
	#AudioPlayer.play_music_level()
	
	#GlobalCount.reset_count()
