extends State
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Hurtbox/CollisionShape2D2"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.state_machine.travel("swordraise_start")
	owner.enrage_sword_spawn()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.attack_meter_animation.play("enrage")
	await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout
	await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout
	
	await owner.attack_meter_animation.animation_finished
	owner.player.untransform_audio.volume_db = -80
	
	if Global.player_data_slots[Global.current_slot_index].first_play_5 == true:
		Global.player_data_slots[Global.current_slot_index].first_play_5 = false
		Global.save_data(Global.current_slot_index)
		
	owner.player.hurtbox_collision.call_deferred("set", "disabled", true)
	collision_shape_2d_2.call_deferred("set", "disabled", true)
	AudioPlayer.stop_music()
	GlobalCount.stage_select_pause = true
	GlobalCount.in_subtree_menu = true
	GlobalCount.timer_active = false
	owner.enrage_animation.play("flash_screen")
	owner.cutscene_player.play("cutscene_between_phase")
	GlobalCount.boss_4_final_health = owner.health_amount
	GlobalCount.boss_4_final_player_mana = player.mana
	await owner.cutscene_player.animation_finished
	owner.cutscene_player.play("idle_cutscene")
