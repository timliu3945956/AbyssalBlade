extends State

@onready var collision: CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"

var direction : Vector2

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)

func enter():
	super.enter()
	
func transition():
	if player_entered:
		GlobalCount.timer_active = true
		GlobalCount.can_pause = false
		GlobalCount.can_charge = true
		owner.player.charge_icon.value = 0
		
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data_slots[Global.current_slot_index].first_play_1 == true:
					Global.player_data_slots[Global.current_slot_index].attempt_count_1 += 1
					Global.save_data(Global.current_slot_index)
					print("boss_0 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_1)
			"BossRoom1":
				if Global.player_data_slots[Global.current_slot_index].first_play_2 == true:
					Global.player_data_slots[Global.current_slot_index].attempt_count_2 += 1
					Global.save_data(Global.current_slot_index)
					print("boss_1 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_2)
			"BossRoom2":
				if Global.player_data_slots[Global.current_slot_index].first_play_3 == true:
					Global.player_data_slots[Global.current_slot_index].attempt_count_3 += 1
					Global.save_data(Global.current_slot_index)
					print("boss_2 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_3)
			"BossRoom3":
				if Global.player_data_slots[Global.current_slot_index].first_play_4 == true:
					Global.player_data_slots[Global.current_slot_index].attempt_count_4 += 1
					Global.save_data(Global.current_slot_index)
					print("boss_3 attempts: ", Global.player_data_slots[Global.current_slot_index].attempt_count_4)
		
		#var boss_music = preload("res://audio/music/boss 2 music (loop-ready).wav")
		AudioPlayer.play_music(owner.boss_music.stream, -40)
		get_parent().change_state("AttackCombo") #AttackCombo

func _on_player_detection_body_entered(body: Node2D) -> void:
	player_entered = true
