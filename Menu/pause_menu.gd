extends Control

var paused = false

@onready var game_start_fx = preload("res://audio/sfx/Menu/Game Start.wav")
@onready var back_button = preload("res://audio/sfx/Menu/Back.wav")

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2

@onready var lobby: Button = $VBoxContainer/Lobby
@onready var main_menu: Button = $VBoxContainer/MainMenu

func _ready():
	self.hide()
	v_box_container_2.visible = false
	if get_tree().current_scene.name == "LobbyScene":
		lobby.visible = false
		main_menu.visible = true
	else:
		lobby.visible = true
		main_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and GlobalCount.can_pause and !get_tree().current_scene.name == "Settings":
		pause_menu()
		
func pause_menu():
	if paused:
		self.hide()
		get_tree().paused = false
	else:
		self.show()
		get_tree().paused = true
		
	paused = !paused
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and v_box_container_2.visible == true and get_tree().paused == true and !get_tree().current_scene.name == "Settings":
		AudioPlayer.play_FX(back_button, -15)
		v_box_container.visible = true
		v_box_container_2.visible = false

func _on_resume_pressed() -> void:
	pause_menu()


#func _on_settings_pressed() -> void:
	#get_tree().paused = false
	#AudioPlayer.play_FX(game_start_fx, -15)
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	#GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	#print(GlobalCount.previous_scene_path)
	#get_tree().change_scene_to_file("res://Menu/Settings.tscn")
	

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioPlayer.play_FX(back_button, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Levels/MainMenu.tscn")


func _on_options_pressed() -> void:
	get_tree().paused = false
	AudioPlayer.play_FX(game_start_fx, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	print(GlobalCount.previous_scene_path)
	get_tree().change_scene_to_file("res://Menu/Settings.tscn")


#func _on_back_pressed() -> void:
	#AudioPlayer.play_FX(back_button, -15)
	#v_box_container_2.visible = false
	#v_box_container.visible = true


func _on_lobby_pressed() -> void:
	get_tree().paused = false
	AudioPlayer.play_FX(game_start_fx, -15)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")
