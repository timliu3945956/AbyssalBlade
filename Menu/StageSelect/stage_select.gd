extends Control

@onready var stage_1_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage1Button
@onready var stage_2_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage2Button
@onready var stage_3_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage3Button
@onready var stage_4_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage4Button
@onready var stage_5_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Stage5Button

@onready var stage_buttons := [
	$PanelContainer/MarginContainer/VBoxContainer/Stage1Button,
	$PanelContainer/MarginContainer/VBoxContainer/Stage2Button,
	$PanelContainer/MarginContainer/VBoxContainer/Stage3Button,
	$PanelContainer/MarginContainer/VBoxContainer/Stage4Button,
	$PanelContainer/MarginContainer/VBoxContainer/Stage5Button
]

@onready var game_start_fx = preload("res://audio/sfx/Menu/ui_start game.wav")
@onready var select_stage_fx = preload("res://audio/sfx/Menu/click.mp3")
@onready var back_button = preload("res://audio/sfx/Menu/ui_back.wav")

@onready var boss_0: Sprite2D = $Boss0
@onready var boss_1: Sprite2D = $Boss1
@onready var boss_2: Sprite2D = $Boss2
@onready var boss_3: Sprite2D = $Boss3
@onready var boss_4: Sprite2D = $Boss4

@onready var description_container: PanelContainer = $DescriptionContainer

@onready var title_1: Label = $DescriptionContainer/DenialTitle
@onready var title_2: Label = $DescriptionContainer/AngerTitle
@onready var title_3: Label = $DescriptionContainer/BargainTitle
@onready var title_4: Label = $DescriptionContainer/DepressionTitle
@onready var title_5: Label = $DescriptionContainer/AcceptanceTitle

@onready var panel_container_2: Control = $PanelContainer2
@onready var stage_1_clear_time: Label = $PanelContainer2/ClearTime
@onready var stage_2_clear_time: Label = $PanelContainer2/ClearTime2
@onready var stage_3_clear_time: Label = $PanelContainer2/ClearTime3
@onready var stage_4_clear_time: Label = $PanelContainer2/ClearTime4
@onready var stage_5_clear_time: Label = $PanelContainer2/ClearTime5

@onready var abyss_clear_time_1: Label = $AbyssModeTimes/AbyssClearTime1
@onready var abyss_clear_time_2: Label = $AbyssModeTimes/AbyssClearTime2
@onready var abyss_clear_time_3: Label = $AbyssModeTimes/AbyssClearTime3
@onready var abyss_clear_time_4: Label = $AbyssModeTimes/AbyssClearTime4
@onready var abyss_clear_time_5: Label = $AbyssModeTimes/AbyssClearTime5
@onready var abyss_mode_times: Control = $AbyssModeTimes


@onready var clear_count_1: Label = $ClearCount/ClearCount1
@onready var clear_count_2: Label = $ClearCount/ClearCount2
@onready var clear_count_3: Label = $ClearCount/ClearCount3
@onready var clear_count_4: Label = $ClearCount/ClearCount4
@onready var clear_count_5: Label = $ClearCount/ClearCount5

@onready var ghost_effect_left: GPUParticles2D = $GhostEffectLeft
@onready var laser_line_left: GPUParticles2D = $LaserLineLeft
@onready var laser_line_right: GPUParticles2D = $LaserLineRight
@onready var ghostly_effect_right: GPUParticles2D = $GhostlyEffectRight

@onready var personal_best_label: Label = $DescriptionContainer/PersonalBestLabel
#@onready var leaderboard_panel: Panel = $DescriptionContainer/Leaderboard
@onready var desc_lead: TextureButton = $AbyssMode/DescLead
@onready var desc_lead_2: Button = $AbyssMode/DescLead2

@onready var abyss_mode: Control = $AbyssMode

@onready var unlock_text: Panel = $UnlockText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var background: Panel = $Background

@onready var play: Button = $Play
@onready var player: CharacterBody2D = $"../.."
@onready var abyss_underlay: Sprite2D = $"../AbyssUnderlay"
@onready var abyss_overlay: Sprite2D = $"../AbyssOverlay"
@onready var transform_fire_bar: GPUParticles2D = $"../TransformFireBar"
@onready var manabar: ProgressBar = $"../Manabar"
@onready var dash_meter: ProgressBar = $"../DashMeter"


var titles : Array[Label]
#var descs : Array[Label]
var clear_times : Array[Label]
var clear_counts: Array[Label]

#enum PanelMode { DESCRIPTION, LEADERBOARD }
#var panel_mode : PanelMode = PanelMode.DESCRIPTION
var current_stage: int = -1

const TEX_ABYSS_OFF : Texture2D = preload("res://Utilities/menu/stage select/stage_select_revamp/buttons/button_abyssmode.png")
const TEX_ABYSS_ON : Texture2D = preload("res://Utilities/menu/stage select/stage_select_revamp/buttons/button_abyssmode_select.png")
const TEX_PB_PRE : Texture2D = preload("res://Utilities/menu/stage select/stage_select_revamp/buttons/personal_best_pregame_text.png")
const TEX_PB_POST : Texture2D = preload("res://Utilities/menu/stage select/stage_select_revamp/buttons/personal_best_postgame_text.png")
const CLEAR_TIME_OFFSET_POST := Vector2(-10, 14.5)

var _base_clear_time_pos : Vector2
var abyss_times : Array[Label]

var last_entered_button = ""
var which_load = 0
var last_focused_button: Button
var hint_tween : Tween
var abyss_selected := false

func _ready() -> void:
	_base_clear_time_pos = panel_container_2.position
	play.visible = false
	background.visible = true
	var group := ButtonGroup.new()
	for b in stage_buttons:
		b.toggle_mode = true
		b.button_group = group
	#Global.load_data(Global.current_slot_index)
	var boss_number = 2
	var best_time_var = "best_time_boss_%d" % boss_number
	print("Displaying best time for boss 3 ", Global.player_data_slots[Global.current_slot_index].best_time_boss_2)
	stage_1_button.disabled = false
	stage_2_button.visible = !Global.player_data_slots[Global.current_slot_index].first_play_1#true
	stage_3_button.visible = !Global.player_data_slots[Global.current_slot_index].first_play_2 #true
	stage_4_button.visible = !Global.player_data_slots[Global.current_slot_index].first_play_3 #true
	stage_5_button.visible = !Global.player_data_slots[Global.current_slot_index].first_play_4
	
	boss_1.visible = !Global.player_data_slots[Global.current_slot_index].first_play_1
	boss_2.visible = !Global.player_data_slots[Global.current_slot_index].first_play_2
	boss_3.visible = !Global.player_data_slots[Global.current_slot_index].first_play_3
	
	stage_1_clear_time.text = format_time(Global.player_data_slots[Global.current_slot_index].best_time_boss_1)
	stage_2_clear_time.text = format_time(Global.player_data_slots[Global.current_slot_index].best_time_boss_2)
	stage_3_clear_time.text = format_time(Global.player_data_slots[Global.current_slot_index].best_time_boss_3)
	stage_4_clear_time.text = format_time(Global.player_data_slots[Global.current_slot_index].best_time_boss_4)
	stage_5_clear_time.text = format_time(Global.player_data_slots[Global.current_slot_index].best_time_boss_5)
	
	abyss_clear_time_1.text = format_time(Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_1)
	abyss_clear_time_2.text = format_time(Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_2)
	abyss_clear_time_3.text = format_time(Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_3)
	abyss_clear_time_4.text = format_time(Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_4)
	abyss_clear_time_5.text = format_time(Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5)
	
	clear_count_1.text = str(Global.player_data_slots[Global.current_slot_index].clear_count_1)
	clear_count_2.text = str(Global.player_data_slots[Global.current_slot_index].clear_count_2)
	clear_count_3.text = str(Global.player_data_slots[Global.current_slot_index].clear_count_3)
	clear_count_4.text = str(Global.player_data_slots[Global.current_slot_index].clear_count_4)
	clear_count_5.text = str(Global.player_data_slots[Global.current_slot_index].clear_count_5)
	
	titles = [title_1, title_2, title_3, title_4, title_5]
	abyss_times = [abyss_clear_time_1, abyss_clear_time_2, abyss_clear_time_3, abyss_clear_time_4, abyss_clear_time_5]
	#descs = [description_1, description_2, description_3, description_4, description_5]
	clear_times = [stage_1_clear_time, stage_2_clear_time, stage_3_clear_time, stage_4_clear_time, stage_5_clear_time]
	clear_counts = [clear_count_1, clear_count_2, clear_count_3, clear_count_4, clear_count_5]
	
	unlock_text.visible = false
	unlock_text.modulate.a = 0.0
	
	
	desc_lead_2.visible = false
	desc_lead.visible = false
	desc_lead.modulate.a = 0.706
	
	GlobalCount.abyss_mode = false
	_set_abyss_particles(false)
	
	_refresh_toggle_state()
	_show_stage(-1)
	
	if Global.player_data_slots[Global.current_slot_index].first_play_6:
		abyss_mode.visible = false
		
	var campaign_done := _campaign_beaten()
	_apply_personal_best_plate(campaign_done)
	_update_clear_time_position(campaign_done)
	abyss_mode_times.visible = campaign_done
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_pos = event.position
		if not description_container.get_global_rect().has_point(click_pos):
			self.visible = false
	if TransitionScreen.is_transitioning:
		return
	if event.is_action_pressed("pause") and not GlobalCount.first_time_play and not GlobalCount.in_subtree_menu:
		print("PRESSING STAGE SELECT")
		GlobalCount.stage_select_pause = false
		GlobalCount.paused = false
		self.visible = false
		abyss_underlay.visible = true
		abyss_overlay.visible = true
		transform_fire_bar.visible = true
		manabar.visible = true
		dash_meter.visible = true
		AudioPlayer.play_FX(back_button, -10)
		
		accept_event()
			
func _process(delta: float) -> void:
	pass

func format_time(time_in_seconds):
	if time_in_seconds <= 0.0:
		return "-:--:--"
	var minutes = int(time_in_seconds) / 60
	var seconds = int(time_in_seconds) % 60
	var milliseconds = int((time_in_seconds - int(time_in_seconds)) * 100)
	#print("milliseconds time: ", time_in_seconds - seconds)
	return "%2d:%02d:%02d" % [minutes, seconds, milliseconds]
	
func _show_stage(index: int) -> void:
	var show_abyss := _campaign_beaten()
	
	for i in titles.size():
		var show := i == index
		titles[i].visible = show
		#descs[i].visible = show
		clear_times[i].visible = show
		clear_counts[i].visible = show
		
		if show_abyss:
			abyss_times[i].visible = show
		else:
			abyss_times[i].visible = false
	background.visible = index == -1
	play.visible = index != -1
	
func _on_stage_button_pressed(idx: int) -> void:
	if current_stage == idx:
		return
		
	AudioPlayer.play_FX(select_stage_fx, 0)
	which_load = idx + 1
	current_stage = idx
	
	desc_lead_2.visible = true
	desc_lead.visible = true
	
	_refresh_toggle_state()
	_show_stage(idx)
	
func _all_stages_cleared() -> bool:
	for i in range(5):
		if !_stage_cleared(i):
			return false
	return true
	
func _update_clear_time_position(campaign_done: bool) -> void:
	if campaign_done:
		panel_container_2.position = _base_clear_time_pos + CLEAR_TIME_OFFSET_POST
	else:
		panel_container_2.position = _base_clear_time_pos
	
func _on_abyss_toggle_pressed() -> void:
	if desc_lead.disabled:
		return
		
	AudioPlayer.play_FX(select_stage_fx, 0)
	
	abyss_selected = !abyss_selected
	_apply_abyss_skin(abyss_selected)
	_set_abyss_particles(abyss_selected)
	
func _campaign_beaten() -> bool:
	return !Global.player_data_slots[Global.current_slot_index].first_play_6
	
func _abyss_stage_unlocked(stage_idx: int) -> bool:
	if !_campaign_beaten():
		return false
	
	if stage_idx == 0:
		return true
	
	var prev_time_key := "abyss_best_time_boss_%d" % stage_idx
	var prev_time = Global.player_data_slots[Global.current_slot_index][prev_time_key]
	return prev_time > 0.0

func _apply_tb_skin(tex: Texture2D) -> void:
	desc_lead.texture_normal = tex
	desc_lead.texture_pressed = tex
	desc_lead.texture_hover = tex
	desc_lead.texture_focused = tex
	desc_lead.texture_disabled = tex
	
func _refresh_toggle_state() -> void:
	if current_stage == -1 or !_campaign_beaten():
		abyss_mode.visible = false
		return
		
	abyss_mode.visible = true
	var unlocked := _abyss_stage_unlocked(current_stage)
	
	if !unlocked:
		abyss_selected = false
		_set_abyss_particles(false)
	
	desc_lead.disabled = !unlocked
	if unlocked:
		desc_lead.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		desc_lead.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
	if unlocked:
		desc_lead.modulate.a = 0.706
	else:
		desc_lead.modulate.a = 0.3
	
	_apply_abyss_skin( unlocked && abyss_selected )
	
	if hint_tween and hint_tween.is_running():
		hint_tween.kill()
	
	if unlocked:
		unlock_text.visible = false
		unlock_text.modulate.a = 0.0
		#_apply_abyss_skin(abyss_selected)
		#_set_abyss_particles(GlobalCount.abyss_mode)
	else:
		#_apply_abyss_skin(false)
		unlock_text.modulate.a = 0.0
		
func _apply_personal_best_plate(campaign_done: bool) -> void:
	var sb := StyleBoxTexture.new()
	if campaign_done:
		sb.texture = TEX_PB_POST
	else:
		sb.texture = TEX_PB_PRE
	personal_best_label.add_theme_stylebox_override("normal", sb)
	
func _apply_abyss_skin(enabled: bool) -> void:
	var tex
	if enabled:
		tex = TEX_ABYSS_ON
	else:
		tex = TEX_ABYSS_OFF
	_apply_tb_skin(tex)

func _stage_cleared(idx: int) -> bool:
	match idx:
		0: return !Global.player_data_slots[Global.current_slot_index].first_play_1
		1: return !Global.player_data_slots[Global.current_slot_index].first_play_2
		2: return !Global.player_data_slots[Global.current_slot_index].first_play_3
		3: return !Global.player_data_slots[Global.current_slot_index].first_play_4
		4: return !Global.player_data_slots[Global.current_slot_index].first_play_5
		_: return false

func make_uniform_skin(sb: StyleBoxTexture) -> Dictionary:
	return {
		"normal": sb,
		"hover": sb,
		"pressed": sb,
		"focus": sb,
		"hover_pressed": sb
	}

func _fade_unlock_hint(show: bool) -> void:
	if hint_tween and hint_tween.is_running():
		hint_tween.kill()
		
	unlock_text.visible = true
	
	hint_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	
	if show:
		hint_tween.tween_property(unlock_text, "modulate:a", 1.0, 0.25)
	else:
		hint_tween.tween_property(unlock_text, "modulate:a", 0.0, 0.25)
		hint_tween.finished.connect(
			func():
				unlock_text.visible = false
		)
	
func _set_abyss_particles(active: bool) -> void:
	for p in [ghost_effect_left, laser_line_left, laser_line_right, ghostly_effect_right]:
		if p:
			p.emitting = active
			if active:
				p.restart()

func _on_back_pressed() -> void:
	AudioPlayer.play_FX(back_button, -10)
	self.visible = false

func _on_play_pressed() -> void:
	GlobalCount.abyss_mode = abyss_selected
	AudioPlayer.fade_out_music(2.0)
	match which_load:
		1:
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom0.tscn")
		2:
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom1.tscn")
		3:
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom2.tscn")
		4:
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom3.tscn")
		5:
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom4.tscn")
			
func check_button_focus() -> void:
	if last_focused_button != null:
		last_focused_button.grab_focus()


func _on_desc_lead_2_mouse_entered() -> void:
	if desc_lead.disabled:
		_fade_unlock_hint(true)


func _on_desc_lead_2_mouse_exited() -> void:
	if desc_lead.disabled:
		_fade_unlock_hint(false)


func _on_desc_lead_mouse_entered() -> void:
	desc_lead.modulate.a = 1


func _on_desc_lead_mouse_exited() -> void:
	desc_lead.modulate.a = 0.706
	desc_lead.release_focus()
