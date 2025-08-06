extends Control

var paused = false

@onready var game_start_fx = preload("res://audio/sfx/Menu/click.mp3")
@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")
@onready var click = preload("res://audio/sfx/Menu/click.mp3")

@onready var panel: Panel = $Panel
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var lobby: Button = $VBoxContainer/Lobby
@onready var main_menu: Button = $VBoxContainer/MainMenu
@onready var resume: Button = $VBoxContainer/Resume
@onready var controls: Button = $VBoxContainer/Controls
@onready var settings: Button = $VBoxContainer/Settings
@onready var exit: Button = $VBoxContainer/Exit

@onready var player: CharacterBody2D = $"../.."

var controls_screen = preload("res://Menu/Controls.tscn")
var settings_screen = preload("res://Menu/Settings.tscn")
var exit_panel = preload("res://Menu/ExitPanel.tscn")
var show_exit

func _ready():
	self.hide()
	visibility_changed.connect(_on_vis)
	
	InputManager.InputSourceChanged.connect(_on_source_changed)
	
	if get_tree().current_scene.name == "LobbyScene":
		_set_lobby_skin()
		lobby.visible = false
		main_menu.visible = true
		exit.visible = true
	else:
		lobby.visible = true
		main_menu.visible = false
		exit.visible = false
		lobby.focus_neighbor_bottom = resume.get_path()
		resume.focus_neighbor_top = lobby.get_path()

func _on_vis() -> void:
	if visible:
		_grab_resume_if_controller()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_source_changed(src) -> void:
	if not visible:
		return
	
	if src == InputManager.InputSource.CONTROLLER:
		_grab_resume_if_controller()
	else:
		_release_pause_focus()
		
func _release_pause_focus() -> void:
	var owner := get_viewport().gui_get_focus_owner()
	if owner and v_box_container.is_ancestor_of(owner):
		owner.release_focus()
		
func pause_menu():
	AudioPlayer.play_FX(click, 10)
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
		_grab_resume_if_controller()
		#player.set_process(false)
		#player.set_physics_process(false)
		#GlobalCount.paused = true
		#get_tree().paused = true
		#player.set_process_input(false)
		
	paused = !paused
	
func _input(event):
	if is_instance_valid(show_exit):
		return
	if event.is_action_pressed("pause") and !get_tree().current_scene.name == "Settings" and not GlobalCount.stage_select_pause and not GlobalCount.in_subtree_menu and not GlobalCount.first_time_play and not GlobalCount.player_dead:
		pause_menu()
		accept_event()
		print("pausing")
	elif event.is_action_pressed("ui_cancel") and self.visible == true and !get_tree().current_scene.name == "Settings" and not GlobalCount.stage_select_pause and not GlobalCount.in_subtree_menu and not GlobalCount.first_time_play and not GlobalCount.player_dead:
		pause_menu()
		accept_event()
		print("pausing")
func _grab_resume_if_controller() -> void:
	if InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		call_deferred("_deferred_grab")
		
func _deferred_grab() -> void:
	if visible and v_box_container.visible:
		resume.grab_focus()

func _on_resume_pressed() -> void:
	pause_menu()

func _on_controls_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	GlobalCount.stage_select_pause = true
	AudioPlayer.play_FX(click, 10)
	
	panel.hide()
	v_box_container.hide()
	
	var control_panel = controls_screen.instantiate()
	add_child(control_panel)
	control_panel.connect("closed", _on_subtree_closed)

func _on_settings_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	GlobalCount.stage_select_pause = true
	AudioPlayer.play_FX(click, 10)
	
	panel.hide()
	v_box_container.hide()
	
	var setting_panel = settings_screen.instantiate()
	add_child(setting_panel)
	setting_panel.connect("closed", _on_subtree_closed)
	
func _on_subtree_closed() -> void:
	panel.show()
	v_box_container.show()
	_grab_resume_if_controller()

func _on_main_menu_pressed() -> void:
	fade_music_out()
	GlobalCount.is_time_running = false
	Global.save_data(Global.current_slot_index)
	
	AudioPlayer.play_FX(back_button, 5)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.reset_count()
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")

func _on_lobby_pressed() -> void:
	fade_music_out()
	AudioPlayer.play_FX(back_button, 5)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.reset_count()
	get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")

func fade_music_out():
	AudioPlayer.fade_out_music(2.0)

func _on_exit_pressed() -> void:
	show_exit = exit_panel.instantiate()
	add_child(show_exit)
	
	_disable_pause_buttons(true)
	
	show_exit.tree_exited.connect(func():
		_disable_pause_buttons(false))
	
func _disable_pause_buttons(disable: bool) -> void:
	for b in v_box_container.get_children():
		if b is Button:
			b.disabled = disable
			b.focus_mode = Button.FOCUS_NONE if disable else Button.FOCUS_ALL
	
	if InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		resume.grab_focus()
	
func _set_lobby_skin() -> void:
	var tex := preload("res://Utilities/menu/enlarged_lobby_esc_box.png")
	var sb := StyleBoxTexture.new()
	sb.texture = tex
	panel.add_theme_stylebox_override("panel", sb)
	
