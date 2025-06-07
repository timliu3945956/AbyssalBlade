extends Control

var paused = false

@onready var game_start_fx = preload("res://audio/sfx/Menu/click.mp3")
@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")
@onready var click = preload("res://audio/sfx/Menu/click.mp3")

@onready var panel: Panel = $Panel
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var lobby: Button = $VBoxContainer/Lobby
@onready var main_menu: Button = $VBoxContainer/MainMenu


@onready var player: CharacterBody2D = $"../.."

var controls_screen = preload("res://Menu/Controls.tscn")
var settings_screen = preload("res://Menu/Settings.tscn")

func _ready():
	self.hide()
	if get_tree().current_scene.name == "LobbyScene":
		lobby.visible = false
		main_menu.visible = true
	else:
		lobby.visible = true
		main_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func pause_menu():
	AudioPlayer.play_FX(click, 0)
	#if not GlobalCount.stage_select_pause:
	if paused:
		self.hide()
		GlobalCount.paused = false
		#player.set_process(true)
		#player.set_physics_process(true)
		#get_tree().paused = false
		#GlobalCount.paused = false
		#player.set_process_input(true)
	else:
		self.show()
		GlobalCount.paused = true
		#player.set_process(false)
		#player.set_physics_process(false)
		#GlobalCount.paused = true
		#get_tree().paused = true
		#player.set_process_input(false)
		
	paused = !paused
	
func _input(event):
	#if event.is_action_pressed("ui_cancel") and v_box_container_2.visible == true and get_tree().paused == true and !get_tree().current_scene.name == "Settings":
		#AudioPlayer.play_FX(back_button, 0)
		#v_box_container.visible = true
	if event.is_action_pressed("pause") and !get_tree().current_scene.name == "Settings" and not GlobalCount.stage_select_pause and not GlobalCount.in_subtree_menu and not GlobalCount.first_time_play:
		pause_menu()
		accept_event()

func _on_resume_pressed() -> void:
	pause_menu()

func _on_controls_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	AudioPlayer.play_FX(click, 0)
	
	panel.hide()
	v_box_container.hide()
	
	var control_panel = controls_screen.instantiate()
	add_child(control_panel)
	control_panel.connect("closed", _on_subtree_closed)

func _on_settings_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	AudioPlayer.play_FX(click, 0)
	
	panel.hide()
	v_box_container.hide()
	
	var setting_panel = settings_screen.instantiate()
	add_child(setting_panel)
	setting_panel.connect("closed", _on_subtree_closed)
	
func _on_subtree_closed() -> void:
	panel.show()
	v_box_container.show()

func _on_main_menu_pressed() -> void:
	fade_music_out()
	GlobalCount.is_time_running = false
	Global.save_data(Global.current_slot_index)
	
	AudioPlayer.play_FX(back_button, -10)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.reset_count()
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

func _on_lobby_pressed() -> void:
	fade_music_out()
	AudioPlayer.play_FX(back_button, -10)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.reset_count()
	get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")

func fade_music_out():
	AudioPlayer.fade_out_music(2.0)
