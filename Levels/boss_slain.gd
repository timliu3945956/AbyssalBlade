extends CanvasLayer

@onready var time: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer1/Time
@onready var dps: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer2/DPS
#@onready var surge: Label = $Panel2/MarginContainer/VBoxContainer/HBoxContainer3/Surge

func _ready() -> void:
	self.hide()
	time.hide()
	dps.hide()

func boss_slain():
	get_tree().paused = true
	self.show()
	
	await get_tree().create_timer(0.5).timeout
	format_time(GlobalCount.elapsed_time)
	time.show()
	if Global.player_data.best_time_boss_2 == 0.0 or Global.player_data.best_time_boss_2 > GlobalCount.elapsed_time:
		Global.player_data.best_time_boss_2 = GlobalCount.elapsed_time
		Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
		print(Global.player_data.best_time_boss_2)
	#Global.change_best_time(2, GlobalCount.elapsed_time)
	await _label_animation(time, 0, 0.025)
	dps.show()
	var dps_to_int = GlobalCount.dps_count / GlobalCount.elapsed_time
	# GlobalCount.dps_count
	await _label_animation(dps, dps_to_int, 0.010)
	#await _label_animation(surge, GlobalCount.surge_count, 0.099)
	

func _label_animation(label: Label, value: float, duration: float):
	if label == time:
		label.text = format_time(GlobalCount.elapsed_time)
		await get_tree().create_timer(0.5).timeout
	elif label == dps:
		label.text = str(Global.player_data.deaths_boss_2) #"%0.1f" % (GlobalCount.dps_count / GlobalCount.elapsed_time)
		await get_tree().create_timer(1).timeout
	#else:
		#var current_value = 0.0
		#var integer_value= 0
		#var decimal_value = 0.0
		#
		#var target_integer = int(value)
		#var target_decimal = value - target_integer
		#while current_value < value:
			#if integer_value < target_integer:
				#integer_value += 1
				#
			##if decimal_value < target_decimal:
					##decimal_value += 0.1
			#current_value = integer_value
			#current_value = min(current_value, value)
			#
			#label.text = "%0.1f" % current_value
			#
			#await get_tree().create_timer(duration).timeout
		#while current_value < value:
			#
			#if decimal_value < target_decimal:
				#decimal_value += 0.1
			#current_value = min(decimal_value, target_decimal)
			#current_value = integer_value + decimal_value
			#
			#
			#label.text = "%0.1f" % current_value
			#
			#await get_tree().create_timer(duration).timeout
		#label.text = "%0.1f" % value
		#for i in count +1:
			#label.text = str(i)
			#await get_tree().create_timer(duration).timeout
		
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
	
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")
	#AudioPlayer.stop()
	#AudioPlayer.play_music_level()
	
	#GlobalCount.reset_count()
