extends CenterContainer
@onready var player: CharacterBody2D = $Player
@onready var boss_4: CharacterBody2D = $Boss4
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var camera: Camera2D = $Player/Camera2D
@onready var cutscene_camera: Camera2D = $CutsceneCamera

@onready var boss_room_animation_player: AnimationPlayer = $BossRoomAnimationPlayer
@onready var room_change_player: AnimationPlayer = $RoomChangePlayer

@onready var enrage_background: AnimationPlayer = $EnrageBackground

@onready var plunge_in_marker: Marker2D = $PlungeArea2D/PlungeInVFX/Marker2D
@onready var plunge_out_marker: Marker2D = $PlungeArea2D/PlungeOutVFX/Marker2D

@onready var debuff_attacks: Node2D = $DebuffAttacks

@onready var oblivion_pass_dark_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionPassDarkVFX
@onready var oblivion_pass_gold_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionPassGoldVFX
@onready var oblivion_fail_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionFailVFX
@onready var oblivion_pass: CollisionPolygon2D = $OblivionArea2D/OblivionPass
@onready var dark_wind_vfx: AnimatedSprite2D = $OblivionArea2D/DarkWindVFX


@onready var player_cutscene_sprite: Sprite2D = $PlayerCutsceneSprite
@onready var boss_cutscene_sprite: Sprite2D = $BossCutsceneSprite
@onready var knockback_effect: AnimatedSprite2D = $KnockbackEffect
@onready var light_anim: AnimatedSprite2D = $LightAnim
@onready var foreground_arena: Sprite2D = $ForegroundArena

@onready var invisible_attack_audio: AudioStreamPlayer2D = $invisible_attack_audio
@onready var in_out_alternate_audio: AudioStreamPlayer2D = $in_out_alternate_audio

@onready var glass_break_vfx: AnimatedSprite2D = $GlassBreakVFX
@onready var star_flash_vfx: AnimatedSprite2D = $StarFlashVFX

@onready var roar_audio: AudioStreamPlayer2D = $PlayerCutsceneSprite/RoarAudio



# BOSS 3 ONREADY

var octahit = preload("res://Other/ThreeLineAOE.tscn")
var gold_clone = preload("res://Other/gold_clone.tscn")
var cleave = preload("res://Other/half_room_cleave.tscn")
var glass_shard = preload("res://Other/GlassShard.tscn")

var dialogue_resource = preload("res://dialogue/start_game.dialogue")

var spawn_clone

var PHYS_STEP_MS = 1000.0 / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
@export var freeze_threshold_ms : float = 120.0

var _last_tick_ms : int = Time.get_ticks_msec()

func _ready() -> void:
	AudioPlayer.stop_music()
	GlobalCount.reset_count()
	GlobalCount.camera = player.camera
	if GlobalCount.from_stage_select_enter:
		GlobalCount.from_stage_select_enter = false
		GlobalCount.stage_select_pause = true
		GlobalCount.in_subtree_menu = true
		player.set_process(false)
		player.set_physics_process(false)
		GlobalCount.paused = true
		#Global.player_data_slots[Global.current_slot_index].final_boss_cutscene = true #Testing cutscene purpose
		if Global.player_data_slots[Global.current_slot_index].final_boss_cutscene:
			cutscene_player.play("cutscene_1")
			await cutscene_player.animation_finished
			cutscene_player.play("boss_idle")
			await get_tree().create_timer(1.25).timeout
			
			DialogueManager.show_custom_dialogue_balloon("res://dialogue/npc_balloon.tscn", dialogue_resource, "GriefStart")
			await DialogueManager.dialogue_ended
			await get_tree().create_timer(1).timeout
			cutscene_player.play("first_time_cutscene") #new_animation
			await cutscene_player.animation_finished
			Global.player_data_slots[Global.current_slot_index].final_boss_cutscene = false
			Global.save_data(Global.current_slot_index)
		else:
			cutscene_player.play("new_animation")
			await cutscene_player.animation_finished
		GlobalCount.paused = false
		player.set_process(true)
		player.set_physics_process(true)
		GlobalCount.stage_select_pause = false
		GlobalCount.in_subtree_menu = false
	GlobalCount.in_subtree_menu = false

func _process(delta: float) -> void:
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta
		
func _physics_process(_delta):
	var now_ms := Time.get_ticks_msec()
	var gap_ms := now_ms - _last_tick_ms
	_last_tick_ms = now_ms
	
	if gap_ms > PHYS_STEP_MS + freeze_threshold_ms:
		push_warning(
			"[HITCH] physics stalled for %.1f ms (expected %.1f ms)" %
			[gap_ms, PHYS_STEP_MS]
		)
		
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)

func spawn_octahit():
	var spawn_hit = octahit.instantiate()
	spawn_hit.player = player
	spawn_hit.boss = boss_4
	add_child(spawn_hit)

func spawn_gold_clone():
	spawn_clone = gold_clone.instantiate()
	spawn_clone.player = player
	spawn_clone.boss = boss_4
	add_child(spawn_clone)
	
func spawn_shield():
	if is_instance_valid(spawn_clone):
		spawn_clone.animation_player.play("raise_sword")
		
func check_clone_alive():
	if is_instance_valid(spawn_clone):
		print("playing oblivion_pass")
		move_oblivion_collision_vfx()
		#await get_tree().create_timer(0.1667).timeout
		boss_room_animation_player.play("oblivion_pass")
	else:
		print("playing oblivion_fail")
		#await get_tree().create_timer(0.1667).timeout
		boss_room_animation_player.play("oblivion_fail")

func _on_debuff_finished(attack_name: String) -> void:
	debuff_attacks.global_position = player.global_position
	debuff_attacks.animation_player.play(attack_name)
		
func reset_smoothing():
	camera.reset_smoothing()
	
func start_oblivion_vfx():
	oblivion_pass_dark_vfx.play("default")
	oblivion_pass_gold_vfx.play("default")
	oblivion_fail_vfx.play("default")
	boss_4.enrage_fire_pop.emitting = true
	dark_wind_vfx.play("default")

func stop_oblivion_vfx():
	oblivion_pass_dark_vfx.stop()
	oblivion_pass_gold_vfx.stop()
	oblivion_fail_vfx.stop()
	
func play_dark_wind_vfx():
	dark_wind_vfx.play("default")
	
func move_oblivion_collision_vfx():
	oblivion_pass_gold_vfx.global_position = spawn_clone.global_position
	oblivion_pass.global_position = spawn_clone.global_position
	

#///////////////////////////// - Cutscene functions
func change_to_cutscene_camera():
	cutscene_camera.make_current()
	
func change_to_player_camera():
	camera.make_current()

func tween_boss_player():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, 50), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
	var tween_boss = get_tree().create_tween()
	tween_boss.tween_property(boss_cutscene_sprite, "position", boss_cutscene_sprite.position + Vector2(0, -50), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
		
func tween_push_player():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, 45), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
func tween_player_walk():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -35), 1.5)
	
func player_walk_closer():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -10), 1)
	
func player_walk_to_boss():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -25), 2)

func camera_shake_cutscene():
	GlobalCount.camera.apply_shake(25.0, 20.0)
	
func camera_shake_destroy_blade():
	GlobalCount.camera.apply_shake(0.7, 20.0, 4.0)

#func camera_shake_destroy_blade_2():
	#GlobalCount.camera.apply_shake(2.5, 20.0, 2.0)
	
func change_camera():
	GlobalCount.camera = cutscene_camera
	
func change_camera_player():
	GlobalCount.camera = camera
	
func flash_screen():
	enrage_background.play("flash_screen")
	
func spawn_cleave():
	var cleave_spawn = cleave.instantiate()
	cleave_spawn.direction = 1
	cleave_spawn.position = player_cutscene_sprite.position + Vector2(0, 7)
	cleave_spawn.rotation = deg_to_rad(-90)
	cleave_spawn.player = player
	add_child(cleave_spawn)
	
func fade_black():
	TransitionScreen.transition_end_game()
	
func spawn_glass_shard():
	for i in range(75):
		var shard = glass_shard.instantiate()
		shard.origin = boss_cutscene_sprite.global_position
		add_child(shard)
	
func boss_tug_vfx():
	knockback_effect.play_backwards("default")
	
func play_light_anim():
	light_anim.play("default")
	
# BOSS 0 FUNCTIONS
func invisible_attack_sound():
	invisible_attack_audio.play()
	
# BOSS 1 FUNCTIONS
func inout_alternate_audio():
	in_out_alternate_audio.play()
	
# BOSS 2 FUNCTIONS
#func inner_melee_special_vfx():
	#inner_circle_wind.play("default")
	#inner_circle_lightning.play("default")
	#lightning_3.play("default")
	#lightning_ember_inner_1.play("default")
	#lightning_ember_inner_2.play("default")
	#lightning_ember_inner_3.play("default")
	#lightning_ember_inner_4.play("default")
	#lightning_ember_inner_5.play("default")
	#lightning_ember_inner_6.play("default")
	#
#func middle_melee_special_vfx():
	#middle_circle_wind.play("default")
	#middle_circle_lightning.play("default")
	#lightning_vfx_middle_1.play("default")
	#lightning_vfx_middle_2.play("default")
	#lightning_vfx_middle_3.play("default")
	#lightning_vfx_middle_4.play("default")
	#lightning_vfx_middle_5.play("default")
	#lightning_vfx_middle_6.play("default")
	#lightning_ember_middle_1.play("default")
	#lightning_ember_middle_2.play("default")
	#lightning_ember_middle_3.play("default")
	#lightning_ember_middle_4.play("default")
	#lightning_ember_middle_5.play("default")
	#lightning_ember_middle_6.play("default")
	#
#func middle_second_melee_special_vfx():
	#middle_circle_lightning_2.play("default")
	#middle_circle_wind_2.play("default")
	#lightning_vfx_second_1.play("default")
	#lightning_vfx_second_2.play("default")
	#lightning_vfx_second_3.play("default")
	#lightning_vfx_second_4.play("default")
	#lightning_vfx_second_5.play("default")
	#lightning_vfx_second_6.play("default")
	#lightning_ember_middle_second_1.play("default")
	#lightning_ember_middle_second_2.play("default")
	#lightning_ember_middle_second_3.play("default")
	#lightning_ember_middle_second_4.play("default")
	#lightning_ember_middle_second_5.play("default")
	#lightning_ember_middle_second_6.play("default")
	#
#func outer_melee_special_vfx():
	#outer_circle_wind.play("default")
	#outer_circle_lightning.play("default")
	#lightning_vfx_outer_1.play("default")
	#lightning_vfx_outer_2.play("default")
	#lightning_vfx_outer_3.play("default")
	#lightning_vfx_outer_4.play("default")
	#lightning_vfx_outer_5.play("default")
	#lightning_vfx_outer_6.play("default")
	#lightning_ember_outer_1.play("default")
	#lightning_ember_outer_2.play("default")
	#lightning_ember_outer_3.play("default")
	#lightning_ember_outer_4.play("default")
	#lightning_ember_outer_5.play("default")
	#lightning_ember_outer_6.play("default")
	#outer_collision.disabled = false
	#await get_tree().create_timer(0.0833).timeout
	#outer_collision.disabled = true
#
##func spawn_special_counterclockwise() -> void:
	##var range_line_first = ranged_special_initial_2.instantiate()
	##add_child(range_line_first)
	##
	##await get_tree().create_timer(2.75).timeout
	##for i in range(20):
		##var range_special_audio = ranged_audio.instantiate()
		##add_child(range_special_audio)
		##await get_tree().create_timer(0.5).timeout
	##
##func spawn_special_clockwise() -> void:
	##var range_line = ranged_special_2.instantiate()
	##add_child(range_line)
	##
	##await get_tree().create_timer(2.75).timeout
	##for i in range(20):
		##var range_special_audio = ranged_audio.instantiate()
		##add_child(range_special_audio)
		##await get_tree().create_timer(0.5).timeout
		
func turn_object_off():
	GlobalCount.paused = true
	player.set_process(false)
	player.set_physics_process(false)
	player.set_process(false)
	boss_4.set_process(false)

func turn_objects_on():
	GlobalCount.paused = false
	player.set_process(true)
	player.set_physics_process(true)
	player.set_process(true)
	boss_4.set_process(true)
	
func transition_final():
	get_tree().change_scene_to_file("res://Levels/BossRoom4Final.tscn")
	
func glass_break_VFX():
	glass_break_vfx.play("default")
	
func star_flash_VFX():
	star_flash_vfx.play("default")

func take_blade_switch_scene():
	#AudioPlayer.fade_out_music(2.0)
	LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")
	
func tween_camera_boss():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2(0, -45), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func tween_camera_player():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2(0, 0), 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func tween_camera():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "offset", cutscene_camera.offset + Vector2(0, 45), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func tween_camera_start():
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "offset", cutscene_camera.offset + Vector2(0, -45), 2.0)
	
func play_roar_audio():
	AudioPlayer.play_FX(roar_audio.stream, 3)
	
func bad_ending_achievement():
	var achievement_bad_ending = Steam.getAchievement("BadEnding")
	if achievement_bad_ending.ret && !achievement_bad_ending.achieved:
		Steam.setAchievement("BadEnding")
		Steam.storeStats()
	SteamGlobal._check_completionist()
