extends CenterContainer

@onready var stage_select: Control = $Player/CanvasLayer/StageSelect
@onready var player: CharacterBody2D = $Player
@onready var color_rect: ColorRect = $Player/CanvasLayer/ColorRect
@onready var collision_shape_2d: CollisionShape2D = $Mirror/InteractionArea/CollisionShape2D
@onready var camera: Camera2D = $Player/Camera2D
@onready var lobby_music: AudioStreamPlayer2D = $LobbyMusic
@onready var denial_shadow: Node2D = $LobbyDenial
@onready var anger_shadow: Node2D = $LobbyAnger
@onready var bargain_shadow: Node2D = $LobbyBargain
@onready var depression_shadow: Node2D = $LobbyDepression

@onready var tutorial: Node2D = $Tutorial
@onready var lobby_blade: Node2D = $LobbyBlade
@onready var player_camera: Camera2D = $Player/Camera2D
@onready var enter_scene_cutscene: AnimationPlayer = $EnterSceneCutscene

@onready var mirror: Node2D = $Mirror
@onready var canvas_layer: CanvasLayer = $Player/CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.last_music_button = "2"
	color_rect.visible = false
	color_rect.mouse_filter = MOUSE_FILTER_STOP
	stage_select.visible = false
	GlobalCount.can_pause = true
	GlobalCount.can_charge = true
	GlobalCount.from_stage_select_enter = true
	AudioPlayer.play_music(lobby_music.stream, -22)
	GlobalCount.camera = player.camera
	
	denial_shadow.visible = !Global.player_data_slots[Global.current_slot_index].first_play_1
	anger_shadow.visible = !Global.player_data_slots[Global.current_slot_index].first_play_2
	bargain_shadow.visible = !Global.player_data_slots[Global.current_slot_index].first_play_3
	depression_shadow.visible = !Global.player_data_slots[Global.current_slot_index].first_play_4
	if !Global.player_data_slots[Global.current_slot_index].first_play_4:
		tutorial.queue_free()
		lobby_blade.queue_free()
	
	print("GlobalCount.paused check bool: ", GlobalCount.paused)
	GlobalCount.stage_select_pause = true
	GlobalCount.in_subtree_menu = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !stage_select.visible:
		collision_shape_2d.disabled = false
		player.can_move = true
	
func _calc_current_stage() -> int:
	var stage := 0
	if !Global.player_data_slots[Global.current_slot_index].first_play_1:
		stage = 1
	if !Global.player_data_slots[Global.current_slot_index].first_play_2:
		stage = 2
	if !Global.player_data_slots[Global.current_slot_index].first_play_3:
		stage = 3
	if !Global.player_data_slots[Global.current_slot_index].first_play_4:
		stage = 4
	return stage

func _on_color_rect_mouse_entered() -> void:
	pass # Replace with function body.
	
func turn_process_off():
	#GlobalCount.paused = true
	player.set_process(false)
	player.set_physics_process(false)
	
func turn_process_on():
	#GlobalCount.paused = false
	player.set_process(true)
	player.set_physics_process(true)

func reset_smoothing():
	camera.reset_smoothing()

func tween_camera_up():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2(0, -200), 1.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func tween_camera_down():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2(0, 0), 1.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


		
func _display_stage() -> int:
	return min(_calc_current_stage() + 1, 5)

func _on_enter_scene_cutscene_animation_finished(anim_name: StringName) -> void:
	if anim_name != "new_animation":
		
		return
	
	var target_idx := _display_stage()
	print("target_idx:", target_idx)
	print("last_shown_stage:", Global.player_data_slots[Global.current_slot_index].last_shown_stage)
	if target_idx > Global.player_data_slots[Global.current_slot_index].last_shown_stage:
		await get_tree().create_timer(0.5).timeout
		tween_camera_up()
		await get_tree().create_timer(1).timeout
		enter_scene_cutscene.play("clear_stage_anim")
		await get_tree().create_timer(0.5).timeout
		mirror.number_change(target_idx)
		Global.player_data_slots[Global.current_slot_index].last_shown_stage = target_idx
		Global.save_data(Global.current_slot_index)
		#canvas_layer.visible = true
		await get_tree().create_timer(1.6).timeout
		#turn_process_on()
		canvas_layer.visible = true
		turn_process_on()
		GlobalCount.stage_select_pause = false
		GlobalCount.in_subtree_menu = false
	else:
		canvas_layer.visible = true
		turn_process_on()
		GlobalCount.stage_select_pause = false
		GlobalCount.in_subtree_menu = false
		mirror.number_change(target_idx)
