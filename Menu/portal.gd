extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var game_start_fx = preload("res://audio/sfx/Menu/ui_start game.wav")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var collision_shape_2d: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var vfx: Node2D = $VFX
@onready var particles: GPUParticles2D = $VFX/Particles
@onready var player = get_parent().find_child("Player")

var cutscene_dialogue = preload("res://Menu/Cutscene/CutsceneDialogue1.tscn")

func _ready() -> void:
	canvas_layer.visible = false
	collision_shape_2d.disabled = true
	interaction_area.interact = Callable(self, "_on_interact")
	vfx.modulate.a = 0
	particles.emitting = false
	
func _on_interact():
	#vs
	
	canvas_layer.visible = true
	get_tree().paused = true
	
func play_cutscene(cutscene_name: String) -> void:
	var diag = cutscene_dialogue.instantiate()
	diag.select_dialogue = cutscene_name
	get_parent().add_child(diag)
	
func boss_slain():
	match get_tree().get_current_scene().name:
		"BossRoom0":
			Global.player_data_slots[Global.current_slot_index].clear_count_1 += 1
			if Global.player_data_slots[Global.current_slot_index].clear_count_1 == 1:
				Global.player_data_slots[Global.current_slot_index].first_clear_time_1 = GlobalCount.elapsed_time
				
			if GlobalCount.abyss_mode:
				if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_1 == 0.0 or Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_1 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_1 = GlobalCount.elapsed_time
			else:
				if Global.player_data_slots[Global.current_slot_index].best_time_boss_1 == 0.0 or Global.player_data_slots[Global.current_slot_index].best_time_boss_1 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].best_time_boss_1 = GlobalCount.elapsed_time
					#print(Global.player_data_slots[Global.current_slot_index].best_time_boss_1)
				
			if Global.player_data_slots[Global.current_slot_index].first_play_1 == true:
				player.set_process(false)
				player.set_physics_process(false)
				#player.on_boss_defeated()
				Global.player_data_slots[Global.current_slot_index].first_play_1 = false
				
				TransitionScreen.transition()
				await TransitionScreen.on_transition_finished
				play_cutscene("DenialEnd")
			Global.save_data(Global.current_slot_index)
		"BossRoom1":
			Global.player_data_slots[Global.current_slot_index].clear_count_2 += 1
			if Global.player_data_slots[Global.current_slot_index].clear_count_2 == 1:
				Global.player_data_slots[Global.current_slot_index].first_clear_time_2 = GlobalCount.elapsed_time
				
			if GlobalCount.abyss_mode:
				if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_2 == 0.0 or Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_2 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_2 = GlobalCount.elapsed_time
			else:
				if Global.player_data_slots[Global.current_slot_index].best_time_boss_2 == 0.0 or Global.player_data_slots[Global.current_slot_index].best_time_boss_2 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].best_time_boss_2 = GlobalCount.elapsed_time
				
				print(Global.player_data_slots[Global.current_slot_index].best_time_boss_2)
			if Global.player_data_slots[Global.current_slot_index].first_play_2 == true:
				player.set_process(false)
				player.set_physics_process(false)
				Global.player_data_slots[Global.current_slot_index].first_play_2 = false
				
				TransitionScreen.transition()
				await TransitionScreen.on_transition_finished
				play_cutscene("AngerEnd")
			Global.save_data(Global.current_slot_index)
		"BossRoom2":
			Global.player_data_slots[Global.current_slot_index].clear_count_3 += 1
			if Global.player_data_slots[Global.current_slot_index].clear_count_3 == 1:
				Global.player_data_slots[Global.current_slot_index].first_clear_time_3 = GlobalCount.elapsed_time
				
			if GlobalCount.abyss_mode:
				if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_3 == 0.0 or Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_3 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_3 = GlobalCount.elapsed_time
			else:
				if Global.player_data_slots[Global.current_slot_index].best_time_boss_3 == 0.0 or Global.player_data_slots[Global.current_slot_index].best_time_boss_3 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].best_time_boss_3 = GlobalCount.elapsed_time
				
				print(Global.player_data_slots[Global.current_slot_index].best_time_boss_3)
				#best_record = Global.player_data_slots[Global.current_slot_index].best_time_boss_3
			if Global.player_data_slots[Global.current_slot_index].first_play_3 == true:
				player.set_process(false)
				player.set_physics_process(false)
				Global.player_data_slots[Global.current_slot_index].first_play_3 = false
				
				TransitionScreen.transition()
				await TransitionScreen.on_transition_finished
				play_cutscene("BargainEnd")
			Global.save_data(Global.current_slot_index)
		"BossRoom3":
			Global.player_data_slots[Global.current_slot_index].clear_count_4 += 1
			if Global.player_data_slots[Global.current_slot_index].clear_count_4 == 1:
				Global.player_data_slots[Global.current_slot_index].first_clear_time_4 = GlobalCount.elapsed_time
				
			if GlobalCount.abyss_mode:
				if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_4 == 0.0 or Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_4 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_4 = GlobalCount.elapsed_time
			else:
				if Global.player_data_slots[Global.current_slot_index].best_time_boss_4 == 0.0 or Global.player_data_slots[Global.current_slot_index].best_time_boss_4 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].best_time_boss_4 = GlobalCount.elapsed_time
					print(Global.player_data_slots[Global.current_slot_index].best_time_boss_4)
				
			if Global.player_data_slots[Global.current_slot_index].first_play_4 == true:
				player.set_process(false)
				player.set_physics_process(false)
				Global.player_data_slots[Global.current_slot_index].first_play_4 = false
				
				TransitionScreen.transition()
				await TransitionScreen.on_transition_finished
				play_cutscene("DepressionEnd")
			Global.save_data(Global.current_slot_index)
		"BossRoom4Final":
			Global.player_data_slots[Global.current_slot_index].clear_count_5 += 1
			if Global.player_data_slots[Global.current_slot_index].clear_count_5 == 1:
				Global.player_data_slots[Global.current_slot_index].first_clear_time_5 = GlobalCount.elapsed_time
				
			if GlobalCount.abyss_mode:
				if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5 == 0.0 or Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5 = GlobalCount.elapsed_time
			else:
				if Global.player_data_slots[Global.current_slot_index].best_time_boss_5 == 0.0 or Global.player_data_slots[Global.current_slot_index].best_time_boss_5 > GlobalCount.elapsed_time:
					Global.player_data_slots[Global.current_slot_index].best_time_boss_5 = GlobalCount.elapsed_time
					print(Global.player_data_slots[Global.current_slot_index].best_time_boss_5)
				
			if Global.player_data_slots[Global.current_slot_index].first_play_6 == true:
				player.set_process(false)
				player.set_physics_process(false)
				Global.player_data_slots[Global.current_slot_index].first_play_6 = false
			Global.save_data(Global.current_slot_index)
	
	await get_tree().create_timer(2).timeout
	if !get_tree().get_current_scene().name == "BossRoom4Final":
		particles.emitting = true
		var fade_in_portal = get_tree().create_tween()
		fade_in_portal.tween_property(vfx, "modulate:a", 1, 0.5)
		await get_tree().create_timer(0.5).timeout
		collision_shape_2d.disabled = false

func _on_lobby_pressed() -> void:
	get_tree().paused = false
	AudioPlayer.play_FX(game_start_fx, -10)
	LoadManager.load_scene("res://Menu/LobbyScene/lobby_scene.tscn")

#func _on_main_menu_pressed() -> void:
#LoadManager.load_scene("res://Levels/MainMenu.tscn")
func _on_retry_pressed() -> void:
	get_tree().paused = false
	AudioPlayer.play_FX(game_start_fx, -10)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().reload_current_scene()

func _on_next_stage_pressed() -> void:
	match get_tree().get_current_scene().name:
		"BossRoom0":
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom1.tscn")
		"BossRoom1":
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom2.tscn")
		"BossRoom2":
			AudioPlayer.play_FX(game_start_fx, -10)
			LoadManager.load_scene("res://Levels/BossRoom3.tscn")
