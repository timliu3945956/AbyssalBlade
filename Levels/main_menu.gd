extends Control

@onready var game_start_fx = preload("res://audio/sfx/Menu/click.mp3")
@onready var file_select_fx = preload("res://audio/sfx/Menu/ui_start game.wav")
@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")
@onready var click = preload("res://audio/sfx/Menu/click.mp3")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

@onready var color_rect: ColorRect = $ColorRect
#@onready var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
@onready var menu_music: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var menu_buttons := [
	$"VBoxContainer/Start Game",
	$VBoxContainer/Settings,
	$VBoxContainer/Credits,
	$VBoxContainer/Exit
]

@onready var menu_hovers := [
	$"VBoxContainer/Start Game/HoverStart",
	$VBoxContainer/Settings/HoverSettings,
	$VBoxContainer/Credits/HoverCredits,
	$VBoxContainer/Exit/HoverExit
]

@onready var control: Control = $Control
@onready var start_game: Button = $"VBoxContainer/Start Game"
@onready var exit: Button = $VBoxContainer/Exit

@onready var logo: Panel = $Logo
@onready var version: Panel = $Version
@onready var all_right_reserved: Panel = $AllRightReserved


@onready var fire_middle: GPUParticles2D = $"fire middle"

@onready var play_time_label_1: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/PlayTimeLabel1
@onready var play_time_label_2: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/PlayTimeLabel2
@onready var play_time_label_3: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/PlayTimeLabel3
@onready var time_played_1: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/TimePlayed1
@onready var time_played_2: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/TimePlayed2
@onready var time_played_3: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/TimePlayed3
@onready var new_game_1: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/NewGame1
@onready var new_game_2: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/NewGame2
@onready var new_game_3: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/NewGame3
@onready var save_1: Button = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1
@onready var save_2: Button = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2
@onready var save_3: Button = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3
@onready var death_label_1: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/DeathLabel1
@onready var death_count_1: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/DeathCount1
@onready var death_label_2: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/DeathLabel2
@onready var death_count_2: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/DeathCount2
@onready var death_label_3: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/DeathLabel3
@onready var death_count_3: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/DeathCount3

@onready var press_any_button: Button = $PressAnyButton

@onready var sword_sprite_1: Sprite2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/SwordSprite1
@onready var sword_sprite_2: Sprite2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/SwordSprite2
@onready var sword_sprite_3: Sprite2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/SwordSprite3

@onready var gem_sprites := [
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save1/SwordSprite1/GemCount1,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save2/SwordSprite2/GemCount2,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save3/SwordSprite3/GemCount3
]

@onready var gold_gems := [
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save1/SwordSprite1/GemCount1/GoldGemCount1,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save2/SwordSprite2/GemCount2/GoldGemCount2,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save3/SwordSprite3/GemCount3/GoldGemCount3
]

@onready var highlight_panels := [
	$Control/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer1,
	$Control/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer2,
	$Control/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer3
]

@onready var slot_buttons := [
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save1,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save2,
	$Control/PanelContainer/MarginContainer/VBoxContainer/Save3
]

@onready var delete_buttons := [
	$Control/ManageSaveFile/DeleteFile1,
	$Control/ManageSaveFile/DeleteFile2,
	$Control/ManageSaveFile/DeleteFile3
]
@onready var selected_icons := [
	$Control/ManageSaveFile/SelectedFile1,
	$Control/ManageSaveFile/SelectedFile2,
	$Control/ManageSaveFile/SelectedFile3
]
@onready var blink_animation: AnimationPlayer = $BlinkAnimation

@onready var manage_save_file: Control = $Control/ManageSaveFile
@onready var delete_popup: Control = $Control/DeletePopup
@onready var sub_menu_button: Button = $Control/SubMenuControl/SubMenuButton
@onready var controller_interact_button: Sprite2D = $Control/SubMenuControl/ControllerInteractButton
@onready var sub_menu_control: Control = $Control/SubMenuControl
@onready var exit_panel: Control = $ExitPanel

@onready var gold_particles_1: GPUParticles2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save1/GoldParticles1
@onready var gold_particles_2: GPUParticles2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save2/GoldParticles2
@onready var gold_particles_3: GPUParticles2D = $Control/PanelContainer/MarginContainer/VBoxContainer/Save3/GoldParticles3


@onready var yes_button: Button = $ExitPanel/Panel/VBoxContainer/YesButton

@onready var sword_sprites := [sword_sprite_1, sword_sprite_2, sword_sprite_3]
@onready var death_labels := [death_label_1, death_label_2, death_label_3]
@onready var death_counts := [death_count_1, death_count_2, death_count_3]
@onready var play_time_labels := [play_time_label_1, play_time_label_2, play_time_label_3]
@onready var time_played_labels := [time_played_1, time_played_2, time_played_3]
@onready var new_game_labels := [new_game_1, new_game_2, new_game_3]

const BOSS_FLAGS := ["first_play_1", "first_play_2", "first_play_3", "first_play_4", "first_play_6"]

const GOLD_BOSS_FLAGS := [
	"abyss_best_time_boss_1",
	"abyss_best_time_boss_2",
	"abyss_best_time_boss_3",
	"abyss_best_time_boss_4"
]

const GEM_TEXTURES = [
	preload("res://Utilities/menu/save file/gems_1.png"),
	preload("res://Utilities/menu/save file/gems_2.png"),
	preload("res://Utilities/menu/save file/gems_3.png"),
	preload("res://Utilities/menu/save file/gems_4.png"),
	preload("res://Utilities/menu/save file/gems_clear.png")
]

const GOLD_TEXTURES = [
	preload("res://Utilities/menu/save file/gold_gems_1.png"),
	preload("res://Utilities/menu/save file/gold_gems_2.png"),
	preload("res://Utilities/menu/save file/gold_gems_3.png"),
	preload("res://Utilities/menu/save file/gold_gems_4.png")
]

var LobbyScenePath = preload("res://Menu/LobbyScene/lobby_scene.tscn")
var settings_screen = preload("res://Menu/Settings.tscn")

var AbyssModeUnlocked = preload("res://Menu/LobbyScene/AbyssModeUnlock.tscn")
var abyss_mode_popup

var previous_axis_value = 0.0
var deadzone = 0.5
var event_rest: bool = true

const HOVER_FADE := 0.12
var hover_tween: Tween = null
const NEW_SLOT_TX := preload("res://Utilities/menu/save file/Save_newgame.png")
const COMPLETE_SLOT_TX := preload("res://Utilities/menu/save file/Save_File__complete.png")

const M_PASS := Control.MOUSE_FILTER_PASS
const M_IGNORE := Control.MOUSE_FILTER_IGNORE

var input_locked: bool = true

var save_slot_locked := false

func _ready() -> void:
	_apply_input_source(InputManager.activeInputSource)
	InputManager.InputSourceChanged.connect(_apply_input_source)
	press_any_button.disabled = true
	input_locked = true
	#Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME) #Reset Player Data
	#print("boss_0 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_1)
	#print("boss_1 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_2)
	#print("boss_2 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_3)
	
	
		
	#var menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
	AudioPlayer.play_music(menu_music.stream, -10)
	
	#await get_tree().create_timer(2.09).timeout
	var tween_logo = get_tree().create_tween()
	tween_logo.tween_property(logo, "modulate:a", 1.0, 0.3)
	var tween_all_rights = get_tree().create_tween()
	tween_all_rights.tween_property(all_right_reserved, "modulate:a", 1.0, 0.3)
	var tween_version = get_tree().create_tween()
	tween_version.tween_property(version, "modulate:a", 1.0, 0.3)
	var tween_press_any_button = get_tree().create_tween()
	tween_press_any_button.tween_property(press_any_button, "self_modulate:a", 1.0, 0.3)
	await get_tree().create_timer(0.3).timeout
	animation_player_2.play("pulse_button")
	press_any_button.disabled = false
	input_locked = false
	sub_menu_button.disabled = true
	
	
	color_rect.visible = false
	#GlobalCount.reset_count()
	v_box_container.visible = false
	press_any_button.visible = true
	control.visible = false
	GlobalCount.can_pause = false
	
	if Global.player_data_slots[0].time_played <= 0.0:
		sword_sprite_1.visible = false
		death_label_1.visible = false
		death_count_1.visible = false
		play_time_label_1.visible = false
		time_played_1.visible = false
		new_game_1.visible = true
		save_1.text = ""
		new_game_1.modulate.a = 1
		mark_slot_as_new(save_1, NEW_SLOT_TX)
		delete_buttons[0].visible = false
	else:
		sword_sprite_1.visible = true
		death_label_1.visible = true
		death_count_1.text = str(Global.player_data_slots[0].deaths)
		play_time_label_1.visible = true
		time_played_1.text = format_time(Global.player_data_slots[0].time_played)
		new_game_2.visible = false
		save_1.text = "Save 1"
		if !Global.player_data_slots[0].first_play_6:
			mark_slot_as_new(save_1, COMPLETE_SLOT_TX)
		delete_buttons[0].visible = true
	
	if Global.player_data_slots[1].time_played <= 0.0:
		sword_sprite_2.visible = false
		death_label_2.visible = false
		death_count_2.visible = false
		play_time_label_2.visible = false
		time_played_2.visible = false
		new_game_2.visible = true
		save_2.text = ""
		new_game_2.modulate.a = 1
		mark_slot_as_new(save_2, NEW_SLOT_TX)
		delete_buttons[1].visible = false
	else:
		sword_sprite_2.visible = true
		death_label_2.visible = true
		death_count_2.text = str(Global.player_data_slots[1].deaths)
		play_time_label_2.visible = true
		time_played_2.text = format_time(Global.player_data_slots[1].time_played)
		new_game_2.visible = false
		save_2.text = "Save 2"
		if !Global.player_data_slots[1].first_play_6:
			mark_slot_as_new(save_2, COMPLETE_SLOT_TX)
		delete_buttons[1].visible = true
	
	if Global.player_data_slots[2].time_played <= 0.0:
		sword_sprite_3.visible = false
		death_label_3.visible = false
		death_count_3.visible = false
		play_time_label_3.visible = false
		time_played_3.visible = false
		new_game_3.visible = true
		save_3.text = ""
		new_game_3.modulate.a = 1
		mark_slot_as_new(save_3, NEW_SLOT_TX)
		delete_buttons[2].visible = false
	else:
		sword_sprite_3.visible = true
		death_label_3.visible = true
		death_count_3.text = str(Global.player_data_slots[2].deaths)
		play_time_label_3.visible = true
		time_played_3.text = format_time(Global.player_data_slots[2].time_played)
		new_game_3.visible = false
		save_3.text = "Save 3"
		if !Global.player_data_slots[2].first_play_6:
			mark_slot_as_new(save_3, COMPLETE_SLOT_TX)
		delete_buttons[2].visible = true
		
	
		
	update_save_slots()
	for p in highlight_panels:
		p.modulate.a = 0.0
		
	for i in slot_buttons.size():
		slot_buttons[i].connect("mouse_entered", _on_slot_hover.bind(i))
		slot_buttons[i].connect("focus_entered", _on_slot_hover.bind(i))
		
	for i in delete_buttons.size():
		delete_buttons[i].connect("mouse_entered", _on_delete_hover.bind(i))
		delete_buttons[i].connect("focus_entered", _on_delete_hover.bind(i))
		
		delete_buttons[i].connect("mouse_exited", _on_delete_exit.bind(i))
		delete_buttons[i].connect("focus_exited", _on_delete_exit.bind(i))
		delete_buttons[i].connect("pressed", _on_delete_button_pressed.bind(i))
		
	manage_save_file.visible = false
	
	for icon in selected_icons:
		icon.visible = false
	
	if Global.player_data_slots[0].time_played <= 0.0 and Global.player_data_slots[1].time_played <= 0.0 and Global.player_data_slots[2].time_played <= 0.0:
		sub_menu_control.visible = false
		
	delete_popup.slot_deleted.connect(_on_slot_wiped)
	delete_popup.visible = false
	
	#v_box_container.visibility_changed.connect(_on_main_menu_visibility_changed)
	delete_popup.visibility_changed.connect(
		func():
			if not delete_popup.visible:
				_disable_save_slot_ui(false)
	)
	
	for h in menu_hovers:
		h.visible = false
		#h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#for p in highlight_panels:
		#p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	for i in range(menu_buttons.size()):
		var btn = menu_buttons[i]
		btn.connect("mouse_entered", _on_menu_hover.bind(i))
		btn.connect("focus_entered", _on_menu_hover.bind(i))
		btn.connect("mouse_exited", _on_menu_unhover.bind(i))
		btn.connect("focus_exited", _on_menu_unhover.bind(i))
		
	#if Global.player_data_slots[Global.current_slot_index].abyss_mode_popup and not Global.player_data_slots[Global.current_slot_index].first_play_6:
		#Global.player_data_slots[Global.current_slot_index].abyss_mode_popup = false
		#Global.save_data(Global.current_slot_index)
		#AudioPlayer.play_FX(click, 10)
		#abyss_mode_popup = AbyssModeUnlocked.instantiate()
		#add_child(abyss_mode_popup)
		
	if Global.player_data_slots[0].abyss_best_time_boss_5 > 0.0:
		gold_particles_1.visible = true
		sword_sprites[0].material.set_shader_parameter("fade_alpha", 1)
	if Global.player_data_slots[1].abyss_best_time_boss_5 > 0.0:
		gold_particles_2.visible = true
		sword_sprites[1].material.set_shader_parameter("fade_alpha", 1)
	if Global.player_data_slots[2].abyss_best_time_boss_5 > 0.0:
		gold_particles_3.visible = true
		sword_sprites[2].material.set_shader_parameter("fade_alpha", 1)
	
func _apply_input_source(source: int) -> void:
	var using_controller := source == InputManager.InputSource.CONTROLLER
	
	var new_filter := M_IGNORE if using_controller else M_PASS
	
	for btn in menu_buttons:
		btn.mouse_filter = new_filter
		
	if using_controller and v_box_container.visible:
		_grab_first_menu_button()
		
	#for btn in menu_buttons:
		#btn.focus_mode = Control.FOCUS_ALL if using_controller else Control.FOCUS_NONE

func _on_menu_hover(idx:int) -> void:
	for j in range(menu_hovers.size()):
		menu_hovers[j].visible = (j == idx)
		
func _on_menu_unhover(idx:int) -> void:
	var owner := get_viewport().gui_get_focus_owner()
	for j in range(menu_hovers.size()):
		menu_hovers[j].visible = (menu_buttons[j] == owner)

#func _on_main_menu_visibility_changed() -> void:
	#if v_box_container.visible and InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		#_grab_first_menu_button()
		
func _grab_first_menu_button() -> void:
	print("grabbing first menu button focus")
	for child in v_box_container.get_children():
		if child is BaseButton and child.visible and child.focus_mode != Control.FOCUS_NONE:
			child.grab_focus()
			return
			
func _first_focusable(container: Control) -> BaseButton:
	for child in container.get_children():
		if child is BaseButton and child.visible and child.focus_mode != Control.FOCUS_NONE:
			return child
		elif child is Control:
			var nested := _first_focusable(child)
			if nested:
				return nested
	return null
	
func _ensure_focus(event: InputEvent) -> void:
	if InputManager.activeInputSource != InputManager.InputSource.CONTROLLER:
		return
		
	if not (event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event is InputEventJoypadMotion):
		return
	
	if get_viewport().gui_get_focus_owner() != null:
		return
	
	var target_panel : Control = null
	if delete_popup.visible:
		target_panel = delete_popup
	elif control.visible:
		target_panel = control
	elif v_box_container.visible:
		target_panel = v_box_container
	else:
		return
	
	var btn := _first_focusable(target_panel)
	if btn:
		btn.grab_focus()

func _input(event: InputEvent) -> void:
	if is_instance_valid(abyss_mode_popup):
		return
	if input_locked:
		get_viewport().set_input_as_handled()
		return
		
	_ensure_focus(event)
		
	#if v_box_container.visible and get_viewport().gui_get_focus_owner() == null and  (event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event is InputEventJoypadMotion):
		#_grab_first_menu_button()
	if event.is_action_pressed("ui_cancel") and exit_panel.visible:
		_on_exit_pressed()
	if event is InputEventKey and event.pressed and not event.echo and press_any_button.visible == true and not press_any_button.disabled:
		_on_press_any_button_pressed()
	elif event is InputEventJoypadButton and event.pressed and press_any_button.visible == true and not press_any_button.disabled:
		_on_press_any_button_pressed()

	if event.is_released():
		event_rest = true
	if event_rest == false:
		return
	elif event.is_action_pressed("ui_up"):
		if event.is_pressed() and event_rest:
			event_rest = false
			
		#elif event.is_released():
			#event_rest = true
	elif event.is_action_pressed("ui_down"):
		if event.is_pressed() and event_rest:
			event_rest = false
		elif event.is_released():
			event_rest = true
	if event.is_action_pressed("pause") and sub_menu_control.visible and control.visible and InputManager.activeInputSource == InputManager.InputSource.CONTROLLER and !delete_popup.visible:
		manage_save_file.visible = !manage_save_file.visible
	elif event.is_action_pressed("interact") and sub_menu_control.visible and control.visible and InputManager.activeInputSource == InputManager.InputSource.KEYBOARD and !delete_popup.visible:
		manage_save_file.visible = !manage_save_file.visible#_on_sub_menu_button_pressed()
	if event.is_action_pressed("ui_cancel") and control.visible == true:
		if manage_save_file.visible:
			manage_save_file.visible = !manage_save_file.visible#_on_sub_menu_button_pressed()
			return
		control.visible = false
		v_box_container.visible = true
		logo.visible = true
		fire_middle.visible = true
		AudioPlayer.play_FX(back_button, 5)
		
func _on_slot_hover(slot_idx: int) -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	blink_animation.play("panel_%d" % (slot_idx + 1))
		
	highlight_panels[slot_idx].modulate.a = 1.0
	
	hover_tween = get_tree().create_tween()
	for i in highlight_panels.size():
		if i == slot_idx:
			continue
		hover_tween.tween_property(highlight_panels[i], "modulate:a", 0.0, HOVER_FADE).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func bosses_defeated(slot_index: int) -> int:
	var data = Global.player_data_slots[slot_index]
	var beaten := 0
	for flag in BOSS_FLAGS:
		if !data.get(flag):
			beaten += 1
	return beaten
	
func gem_texture_for(slot_index:int) -> Texture2D:
	var data = Global.player_data_slots[slot_index]
	var beaten := bosses_defeated(slot_index)
	
	if beaten == 0:
		gem_sprites[slot_index].visible = false
		return null
	#if beaten >= 4: # and Global.player_data_slots[slot_index].game_clear
		#return GEM_TEXTURES[4]
		
	return GEM_TEXTURES[beaten - 1]
	
func gold_texture_for(slot_index: int) -> int:
	var data = Global.player_data_slots[slot_index]
	var count := 0
	for flag in GOLD_BOSS_FLAGS:
		if data.get(flag) > 0.0:
			count += 1
	return count
		

	
func update_save_slots() -> void:
	for i in range(3):
		var tex := gem_texture_for(i)
		if tex:
			gem_sprites[i].texture = tex
			gem_sprites[i].visible = true
		else:
			gem_sprites[i].visible = false
		
		var gold_count := gold_texture_for(i)
		
		if gold_count > 0:
			gold_gems[i].texture = GOLD_TEXTURES[gold_count - 1]
			gold_gems[i].visible = true
		else:
			gold_gems[i].visible = false

func _on_start_game_pressed() -> void:
	AudioPlayer.play_FX(game_start_fx, 10)
	control.visible = true
	v_box_container.visible = false
	logo.visible = false
	fire_middle.visible = false
	save_1.grab_focus()

func _on_save_1_pressed() -> void:
	if save_slot_locked: return
	save_slot_locked = true
	Global.current_slot_index = 0
	Global.load_data(Global.current_slot_index)
	AudioPlayer.play_FX(file_select_fx, 0)
	
	GlobalCount.is_time_running = true
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	#LobbyScenePath
	if Global.player_data_slots[Global.current_slot_index].first_cutscene:
		GlobalCount.first_time_play = true
		GlobalCount.tutorial_popup = true
		Global.player_data_slots[Global.current_slot_index].first_cutscene = false
		Global.save_data(Global.current_slot_index)
		TransitionScreen.transition_dead()
		AudioPlayer.fade_out_music(4)
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/Cutscene/CutsceneDialogue1.tscn")
	else:
		fade_music_out()
		LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")
	#await fade_music_out()

func _on_save_2_pressed() -> void:
	if save_slot_locked: return
	save_slot_locked = true
	Global.current_slot_index = 1
	Global.load_data(Global.current_slot_index)
	AudioPlayer.play_FX(file_select_fx, 0)
	
	GlobalCount.is_time_running = true
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	if Global.player_data_slots[Global.current_slot_index].first_cutscene:
		GlobalCount.first_time_play = true
		GlobalCount.tutorial_popup = true
		Global.player_data_slots[Global.current_slot_index].first_cutscene = false
		Global.save_data(Global.current_slot_index)
		TransitionScreen.transition_dead()
		AudioPlayer.fade_out_music(4)
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/Cutscene/CutsceneDialogue1.tscn")
	else:
		fade_music_out()
		LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")

func _on_save_3_pressed() -> void:
	if save_slot_locked: return
	save_slot_locked = true
	Global.current_slot_index = 2
	Global.load_data(Global.current_slot_index)
	AudioPlayer.play_FX(file_select_fx, 0)
	
	GlobalCount.is_time_running = true
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	if Global.player_data_slots[Global.current_slot_index].first_cutscene:
		GlobalCount.first_time_play = true
		GlobalCount.tutorial_popup = true
		Global.player_data_slots[Global.current_slot_index].first_cutscene = false
		Global.save_data(Global.current_slot_index)
		TransitionScreen.transition_dead()
		AudioPlayer.fade_out_music(4)
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/Cutscene/CutsceneDialogue1.tscn")
	else:
		fade_music_out()
		LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")
	
func _on_back_pressed() -> void:
	control.visible = false
	v_box_container.visible = true
	logo.visible = true
	fire_middle.visible = true
	AudioPlayer.play_FX(back_button, 5)
	start_game.grab_focus()
	
	
func format_time(time_in_seconds):
	var total_minutes := int(time_in_seconds) / 60
	
	var hours := total_minutes / 60
	var minutes := total_minutes % 60
	
	return "%02d:%02d" % [hours, minutes]


func _on_settings_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	AudioPlayer.play_FX(click, 10)
	
	v_box_container.hide()
	
	var settings_panel = settings_screen.instantiate()
	add_child(settings_panel)
	settings_panel.connect("closed", _on_subtree_closed)

func _on_subtree_closed() -> void:
	v_box_container.show()
	
func fade_music_out():
	AudioPlayer.fade_out_music(2.0)


func _on_press_any_button_pressed() -> void:
	press_any_button.disabled = true
	AudioPlayer.play_FX(file_select_fx, 0)
	animation_player_2.stop()
	
	var tween = get_tree().create_tween()
	var logo_tween = get_tree().create_tween()
	
	tween.tween_property(press_any_button, "modulate:a", 0, 0.3)
	logo_tween.tween_property(logo, "modulate:a", 0, 0.3)
	await tween.finished
	logo.visible = false
	press_any_button.visible = false
	
	v_box_container.visible = true
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(v_box_container, "modulate:a", 1, 0.3)
	
	await tween.finished
	
func mark_slot_as_new(btn: Button, new_tex: Texture2D) -> void:
	for style_name in ["normal", "hover", "pressed", "focus", "disabled"]:
		var old_sb := btn.get_theme_stylebox(style_name)
		var sb_tex: StyleBoxTexture
		if old_sb is StyleBoxTexture:
			sb_tex = old_sb.duplicate()
		else:
			sb_tex = StyleBoxTexture.new()
			sb_tex.content_margin_left = old_sb.content_margin_left
			sb_tex.content_margin_right = old_sb.content_margin_right
			sb_tex.content_margin_top = old_sb.content_margin_top
			sb_tex.content_margin_bottom = old_sb.content_margin_bottom
			
		sb_tex.texture = new_tex
		btn.add_theme_stylebox_override(style_name, sb_tex)
		#var copy := sb.duplicate()
		#copy.texture = new_tex
		#btn.add_theme_stylebox_override(style, copy)
	

func _on_credits_pressed() -> void:
	TransitionScreen.transition_main_menu()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Menu/credits-scene/credits.tscn")


#func _on_sub_menu_button_pressed() -> void:
	#manage_save_file.visible = !manage_save_file.visible
	
func _on_delete_hover(idx:int) -> void:
	for icon in selected_icons:
		icon.visible = false
	selected_icons[idx].visible = true
	
func _on_delete_exit(idx:int) -> void:
	selected_icons[idx].visible = false
	
func _on_delete_button_pressed(slot: int) -> void:
	delete_popup.set_slot(slot)
	delete_popup.show()
	_disable_save_slot_ui(true)
	AudioPlayer.play_FX(click, 10)
	
func _disable_save_slot_ui(locked: bool) -> void:
	const NO_FOCUS := Control.FOCUS_NONE
	const ALL_FOCUS := Control.FOCUS_ALL
	
	for b in slot_buttons:
		b.disabled = locked
		b.focus_mode = NO_FOCUS if locked else ALL_FOCUS
	for b in delete_buttons:
		b.disabled = locked
		b.focus_mode = NO_FOCUS if locked else ALL_FOCUS
	
func _on_slot_wiped(slot: int) -> void:
	_refresh_slot_ui(slot)
	update_save_slots()
	
func _refresh_slot_ui(idx: int) -> void:
	var data = Global.player_data_slots[idx]
	
	var sword = sword_sprites[idx]
	var death_lab = death_labels[idx]
	var death_cnt = death_counts[idx]
	var play_lab = play_time_labels[idx]
	var time_lbl = time_played_labels[idx]
	var new_lbl = new_game_labels[idx]
	var btn = slot_buttons[idx]
	
	if data.time_played <= 0.0:
		sword.visible = false
		death_lab.visible = false
		death_cnt.visible = false
		play_lab.visible = false
		time_lbl.visible = false
		new_lbl.visible = true
		btn.text = ""
		new_game_1.modulate.a = 1
		mark_slot_as_new(btn, NEW_SLOT_TX)
		delete_buttons[idx].visible = false
		
func _show_hover(idx:int) -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
		
	blink_animation.play("panel_%d" % (idx + 1))
	
	for i in highlight_panels.size():
		if i == idx:
			highlight_panels[i].modulate.a = 1.0
		else:
			highlight_panels[i].modulate.a = 0.0
			
	for i in selected_icons.size():
		selected_icons[i].visible = manage_save_file.visible and i == idx
		
func _on_no_button_pressed() -> void:
	exit_panel.visible = !exit_panel.visible

func _on_yes_button_pressed() -> void:
	GlobalCount.is_time_running = false
	Global.save_data(Global.current_slot_index)
	get_tree().quit()

func _on_exit_pressed() -> void:
	AudioPlayer.play_FX(click, 10)
	exit.release_focus()
	exit_panel.visible = !exit_panel.visible
	if InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		yes_button.grab_focus()
