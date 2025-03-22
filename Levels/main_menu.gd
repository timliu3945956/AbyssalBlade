extends Control

@onready var game_start_fx = preload("res://audio/sfx/Menu/Game Start.wav")
@onready var back_button = preload("res://audio/sfx/Menu/Back.wav")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
#@onready var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
@onready var menu_music: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var start_game: Button = $"VBoxContainer/Start Game"

var previous_axis_value = 0.0
var deadzone = 0.5
var event_rest: bool = true

func _ready() -> void:
	#Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME) #Reset Player Data
	print("boss_0 attempts: ", Global.player_data.attempt_count_1)
	print("boss_1 attempts: ", Global.player_data.attempt_count_2)
	print("boss_2 attempts: ", Global.player_data.attempt_count_3)
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	if audio_settings.master_volume == 0.1:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume * 10))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume * 100))
		
	if audio_settings.sfx_volume == 0.1:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_settings.sfx_volume * 10))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_settings.sfx_volume * 100))
	
	if audio_settings.music_volume == 0.1:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume * 10))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume * 100))
		
	#var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
	AudioPlayer.play_music(menu_music.stream, -10)
	color_rect.visible = true
	#print("I come here after main menu press")
	#AudioPlayer.play_music_level(menu_music)
	animation_player.play("fade_to_normal")
	await animation_player.animation_finished
	color_rect.visible = false
	#GlobalCount.reset_count()
	v_box_container.visible = true
	margin_container.visible = false
	GlobalCount.can_pause = false

#func _process(delta):
	#if Input.is_action_just_pressed("ui_down"):
		#_on_joystick_down()
	#elif Input.is_action_just_pressed("ui_up"):
		#_on_joystick_up()
		

func _input(event: InputEvent) -> void:
	if event.is_released():
		event_rest = true
	if event_rest == false:
		return
	elif event.is_action_pressed("ui_up") and InputCheck.deadzone_check():
		if event.is_pressed() and event_rest:
			event_rest = false
			
		#elif event.is_released():
			#event_rest = true
	elif event.is_action_pressed("ui_down") and InputCheck.deadzone_check():
		if event.is_pressed() and event_rest:
			event_rest = false
		elif event.is_released():
			event_rest = true
#func _input(event):
	#
	#if InputCheck.get_input_type():
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#release_focus()
		#start_game.grab_focus()
	#
	#if event is InputEventJoypadMotion:
		#_handle_joypad_motion(event)
	##if event.is_action_pressed("ui_cancel") and margin_container.visible == true:
		##AudioPlayer.play_FX(back_button, -15)
		##v_box_container.visible = true
		##margin_container.visible = false
#
#func _handle_joypad_motion(event: InputEventJoypadMotion):
	#if event.axis == JOY_AXIS_LEFT_Y:
		#var current_axis_value = event.axis_value
		## Checks for axis value crossing deadzone threshold
		#if abs(current_axis_value) > deadzone and abs(previous_axis_value) <= deadzone:
			#if current_axis_value > 0:
				#_on_joystick_down()
			#else:
				#_on_joystick_up()
		#previous_axis_value = current_axis_value
#
#func _on_joystick_down():
	#var current = get_viewport().gui_get_focus_owner()
	#if current:
		#current.move_focus(Control.FOCUS_)
		##var next = current.get_next_focus()
		##if next and next != current:
			##next.grab_focus()
		##else:
			##var first_control = get_first_focusable_control()
			##if first_control:
				##first_control.grab_focus()
	#else:
		#var first_control = get_first_focusable_control()
		#if first_control:
			#first_control.grab_focus()
#
#func _on_joystick_up():
	#var current = get_viewport().gui_get_release_focus()
	#if current:
		#var previous = current.get_previous_focus()
		#if previous and previous != current:
			#previous.grab_focus()
		#else:
			#var last_control = get_last_focusable_control()
			#if last_control:
				#last_control.grab_focus()
	#else:
		#var last_control = get_last_focusable_control()
		#if last_control:
			#last_control.grab_focus()
	#
#func get_first_focusable_control():
	#var focusable_controls = get_focusable_controls()
	#if focusable_controls.size() > 0:
		#return focusable_controls[0]
	#return null
	#
#func get_last_focusable_control():
	#var focusable_controls = get_focusable_controls()
	#if focusable_controls.size() > 0:
		#return focusable_controls[focusable_controls.size() - 1]
	#return null
	#
#func get_focusable_controls():
	#var focusable_controls = []
	#var controls = get_tree().get_nodes_in_group("focusable_controls")
	#for control in controls:
		#if control is Control and control.focus_mode != Control.FOCUS_NONE:
			#focusable_controls.append(control)
	#return focusable_controls

#func _on_start_pressed() -> void:
	
	
	#get_tree().change_scene_to_file("res://Menu/StageSelect/stage_select.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	AudioPlayer.play_FX(game_start_fx, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	get_tree().change_scene_to_file("res://Menu/Settings.tscn")
	#v_box_container.visible = false
	#margin_container.visible = true
	#AudioPlayer.play_FX(game_start_fx, -15)


func _on_settings_pressed() -> void:
	AudioPlayer.play_FX(game_start_fx, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	get_tree().change_scene_to_file("res://Menu/Settings.tscn")


func _on_controls_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	v_box_container.visible = true
	margin_container.visible = false
	AudioPlayer.play_FX(back_button, -15)


func _on_start_game_pressed() -> void:
	AudioPlayer.play_FX(game_start_fx, -15)
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	#GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	#get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")
