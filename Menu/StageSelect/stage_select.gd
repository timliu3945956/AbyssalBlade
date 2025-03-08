extends Control

@onready var stage_1_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage1Button
@onready var stage_2_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage2Button
@onready var stage_3_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage3Button
@onready var stage_4_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage4Button
@onready var stage_5_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage5Button
@onready var game_start_fx = preload("res://audio/sfx/Menu/Game Start.wav")
@onready var back_button = preload("res://audio/sfx/Menu/Back.wav")
@onready var menu_music: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var stage_1_clear_time: Label = $PanelContainer2/ClearTime
@onready var stage_2_clear_time: Label = $PanelContainer2/ClearTime2
@onready var stage_3_clear_time: Label = $PanelContainer2/ClearTime3
@onready var deaths_1: Label = $DeathsContainer/Deaths1
@onready var deaths_2: Label = $DeathsContainer/Deaths2
@onready var deaths_3: Label = $DeathsContainer/Deaths3


#@onready var stage_1_clear_time: Label = $PanelContainer/MarginContainer/VBoxContainer/Stage1Button/MarginContainer/VBoxContainer/HBoxContainer2/ClearTime
#@onready var stage_2_clear_time: Label = $PanelContainer/MarginContainer/VBoxContainer/Stage2Button/MarginContainer/VBoxContainer/HBoxContainer2/ClearTime
#@onready var stage_3_clear_time: Label = $PanelContainer/MarginContainer/VBoxContainer/Stage3Button/MarginContainer/VBoxContainer/HBoxContainer2/ClearTime
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var campfire_particle: GPUParticles2D = $PanelContainer/MarginContainer/VBoxContainer/Stage1Button/CampfireParticle
@onready var background: Panel = $Background

var last_entered_button = ""
var which_load = 1
var begin_background: Tween
var tween_clear_time_1: Tween
var tween_clear_time_2: Tween
var tween_clear_time_3: Tween
var tween_deaths_1: Tween
var tween_deaths_2: Tween
var tween_deaths_3: Tween
#var player_data = PlayerData.new()

func _ready() -> void:
	background.visible = true
	#Global.load_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
	var boss_number = 2
	var best_time_var = "best_time_boss_%d" % boss_number
	print(Global.player_data.best_time_boss_2)
	stage_1_button.disabled = false
	stage_2_button.disabled = false
	stage_3_button.disabled = false
	stage_4_button.disabled = true
	stage_5_button.disabled = true
	
	stage_1_clear_time.modulate.a = 0.0
	stage_2_clear_time.modulate.a = 0.0
	stage_3_clear_time.modulate.a = 0.0
	deaths_1.modulate.a = 0.0
	deaths_2.modulate.a = 0.0
	deaths_3.modulate.a = 0.0
	
	AudioPlayer.play_music(menu_music.stream, -10)
	
	stage_1_clear_time.text = format_time(Global.player_data.best_time_boss_1)
	stage_2_clear_time.text = format_time(Global.player_data.best_time_boss_2)
	stage_3_clear_time.text = format_time(Global.player_data.best_time_boss_3)
	
	deaths_1.text = str(Global.player_data.deaths_boss_1)
	deaths_2.text = str(Global.player_data.deaths_boss_2)
	deaths_3.text = str(Global.player_data.deaths_boss_3)

func _input(event):
	if TransitionScreen.is_transitioning:
		return
	if event.is_action_pressed("ui_cancel"):
		TransitionScreen.is_transitioning = true
		AudioPlayer.play_FX(back_button, -15)
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		if GlobalCount.previous_scene_path != "":
			get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
		else:
			print("No previous scene to return to.")
			
func _process(delta: float) -> void:
	pass


func format_time(time_in_seconds):
	var minutes = int(time_in_seconds) / 60
	var seconds = int(time_in_seconds) % 60
	var milliseconds = int((time_in_seconds - int(time_in_seconds)) * 100)
	#print("milliseconds time: ", time_in_seconds - seconds)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _on_stage_1_button_pressed() -> void:
	_disable_stage_buttons(true)
	which_load = 1
	animation_player.play("boss_idle_0")
	campfire_particle.emitting = true
	if stage_1_clear_time.modulate.a == 0:
		if tween_clear_time_1:
			tween_clear_time_1.kill()
		tween_clear_time_1 = create_tween()
		tween_clear_time_1.tween_property(stage_1_clear_time, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_2_clear_time.modulate.a == 1:
		if tween_clear_time_2:
			tween_clear_time_2.kill()
		tween_clear_time_2 = create_tween()
		tween_clear_time_2.tween_property(stage_2_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_3_clear_time.modulate.a == 1:
		if tween_clear_time_3:
			tween_clear_time_3.kill()
		tween_clear_time_3 = create_tween()
		tween_clear_time_3.tween_property(stage_3_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	if deaths_1.modulate.a == 0:
		if tween_deaths_1:
			tween_deaths_1.kill()
		tween_deaths_1 = create_tween()
		tween_deaths_1.tween_property(deaths_1, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_2.modulate.a == 1:
		if tween_deaths_2:
			tween_deaths_2.kill()
		tween_deaths_2 = create_tween()
		tween_deaths_2.tween_property(deaths_2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_3.modulate.a == 1:
		if tween_deaths_3:
			tween_deaths_3.kill()
		tween_deaths_3 = create_tween()
		tween_deaths_3.tween_property(deaths_3, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if background.modulate.a == 1:
		if begin_background:
			begin_background.kill()
		begin_background = create_tween()
		begin_background.tween_property(background, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	var reenable_timer: Timer = Timer.new()
	reenable_timer.wait_time = 0.5
	reenable_timer.one_shot = true
	add_child(reenable_timer)
	
	reenable_timer.timeout.connect(_on_buttons_reenable)
	reenable_timer.start()
		
func _on_stage_2_pressed() -> void:
	_disable_stage_buttons(true)
	which_load = 2
	animation_player.play("boss_idle_1")
	campfire_particle.emitting = false
	if stage_1_clear_time.modulate.a == 1:
		if tween_clear_time_1:
			tween_clear_time_1.kill()
		tween_clear_time_1 = create_tween()
		tween_clear_time_1.tween_property(stage_1_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_2_clear_time.modulate.a == 0:
		if tween_clear_time_2:
			tween_clear_time_2.kill()
		tween_clear_time_2 = create_tween()
		tween_clear_time_2.tween_property(stage_2_clear_time, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_3_clear_time.modulate.a == 1:
		if tween_clear_time_3:
			tween_clear_time_3.kill()
		tween_clear_time_3 = create_tween()
		tween_clear_time_3.tween_property(stage_3_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	if deaths_1.modulate.a == 1:
		if tween_deaths_1:
			tween_deaths_1.kill()
		tween_deaths_1 = create_tween()
		tween_deaths_1.tween_property(deaths_1, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_2.modulate.a == 0:
		if tween_deaths_2:
			tween_deaths_2.kill()
		tween_deaths_2 = create_tween()
		tween_deaths_2.tween_property(deaths_2, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_3.modulate.a == 1:
		if tween_deaths_3:
			tween_deaths_3.kill()
		tween_deaths_3 = create_tween()
		tween_deaths_3.tween_property(deaths_3, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	if background.modulate.a == 1:
		if begin_background:
			begin_background.kill()
		begin_background = create_tween()
		begin_background.tween_property(background, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	var reenable_timer: Timer = Timer.new()
	reenable_timer.wait_time = 0.5
	reenable_timer.one_shot = true
	add_child(reenable_timer)
	
	reenable_timer.timeout.connect(_on_buttons_reenable)
	reenable_timer.start()

func _on_stage_3_button_pressed() -> void:
	_disable_stage_buttons(true)
	which_load = 3
	animation_player.play("boss_idle_2")
	if stage_1_clear_time.modulate.a == 1:
		if tween_clear_time_1:
			tween_clear_time_1.kill()
		tween_clear_time_1 = create_tween()
		tween_clear_time_1.tween_property(stage_1_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_2_clear_time.modulate.a == 1:
		if tween_clear_time_2:
			tween_clear_time_2.kill()
		tween_clear_time_2 = create_tween()
		tween_clear_time_2.tween_property(stage_2_clear_time, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if stage_3_clear_time.modulate.a == 0:
		if tween_clear_time_3:
			tween_clear_time_3.kill()
		tween_clear_time_3 = create_tween()
		tween_clear_time_3.tween_property(stage_3_clear_time, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	if deaths_1.modulate.a == 1:
		if tween_deaths_1:
			tween_deaths_1.kill()
		tween_deaths_1 = create_tween()
		tween_deaths_1.tween_property(deaths_1, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_2.modulate.a == 1:
		if tween_deaths_2:
			tween_deaths_2.kill()
		tween_deaths_2 = create_tween()
		tween_deaths_2.tween_property(deaths_2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if deaths_3.modulate.a == 0:
		if tween_deaths_3:
			tween_deaths_3.kill()
		tween_deaths_3 = create_tween()
		tween_deaths_3.tween_property(deaths_3, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	if background.modulate.a == 1:
		if begin_background:
			begin_background.kill()
		begin_background = create_tween()
		begin_background.tween_property(background, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	var reenable_timer: Timer = Timer.new()
	reenable_timer.wait_time = 0.5
	reenable_timer.one_shot = true
	add_child(reenable_timer)
	
	reenable_timer.timeout.connect(_on_buttons_reenable)
	reenable_timer.start()

func _on_back_pressed() -> void:
	AudioPlayer.play_FX(back_button, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	if GlobalCount.previous_scene_path != "":
		get_tree().change_scene_to_file(GlobalCount.previous_scene_path)
	else:
		print("No previous scene to return to.")


func _on_play_pressed() -> void:
	match which_load:
		1:
			AudioPlayer.play_FX(game_start_fx, -15)
			LoadManager.load_scene("res://Levels/BossRoom0.tscn")
		2:
			AudioPlayer.play_FX(game_start_fx, -15)
			LoadManager.load_scene("res://Levels/BossRoom1.tscn")
		3:
			AudioPlayer.play_FX(game_start_fx, -15)
			LoadManager.load_scene("res://Levels/BossRoom2.tscn")
			
func _disable_stage_buttons(disabled: bool) -> void:
	stage_1_button.disabled = disabled
	stage_2_button.disabled = disabled
	stage_3_button.disabled = disabled

func _on_buttons_reenable() -> void:
	_disable_stage_buttons(false)
	
