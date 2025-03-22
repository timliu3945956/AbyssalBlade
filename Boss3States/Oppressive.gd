extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	owner.oppressive_debuff_count = owner.oppressive_current_count
	owner.oppressive_pick = randi_range(1, 2)
	
	animation_player.play("idle")
	owner.sword_animation_player.play("swords_idle")
	print("seeing what this equals: ", int(0 / 2))
	owner.attack_meter_animation.play("oppressive")
	if owner.oppressive_pick == 1:
		owner.left_color = "white"
		owner.right_color = "black"
		var red_sword_tween = get_tree().create_tween()
		var blk_white_sword_tween = get_tree().create_tween()
		red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
		blk_white_sword_tween.tween_property(owner.white_black_swords, "modulate:a", 1, 0.5)
		owner.boss_room.white_black_telegraph_start()
		await get_tree().create_timer(3.5).timeout
		owner.boss_room.white_black_telegraph_end()
		
	elif owner.oppressive_pick == 2:
		owner.left_color = "black"
		owner.right_color = "white"
		var red_sword_tween = get_tree().create_tween()
		var blk_white_sword_tween = get_tree().create_tween()
		red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
		blk_white_sword_tween.tween_property(owner.black_white_swords, "modulate:a", 1, 0.5)
		owner.boss_room.black_white_telegraph_start()
		await get_tree().create_timer(3.5).timeout
		owner.boss_room.black_white_telegraph_end()
		
	await owner.attack_meter_animation.animation_finished
	
	animation_player.play("oppressive")
	if owner.left_color == "white": #1 means white is left, blk is right,,, 2 means blk is left, white is right
		owner.boss_room_animation.play("oppressive_left_white")
		owner.boss_room_animation2.play("oppressive_right_black")
		owner.sword_animation_player.play("white_black_oppressive")
	else:
		owner.boss_room_animation.play("oppressive_left_black")
		owner.boss_room_animation2.play("oppressive_right_white")
		owner.sword_animation_player.play("black_white_oppressive")
	await owner.boss_room_animation.animation_finished
	
	await get_tree().create_timer(0.3).timeout
	if owner.oppressive_debuff_count > owner.oppressive_current_count + 1:
		player.kill_player()
		print("killing player, owner.oppressive_current_count")
	owner.oppressive_current_count = owner.oppressive_debuff_count
	
	var blk_white_sword_tween = get_tree().create_tween()
	var white_blk_sword_tween = get_tree().create_tween()
	animation_player.play("standup")
	blk_white_sword_tween.tween_property(owner.white_black_swords, "modulate:a", 0, 0.5)
	white_blk_sword_tween.tween_property(owner.black_white_swords, "modulate:a", 0, 0.5)
	await animation_player.animation_finished
	
	animation_player.play("idle")
	owner.sword_animation_player.play("swords_idle")
	
	
	owner.oppressive_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		match owner.oppressive_count:
			1:
				get_parent().change_state("Barrage")
			2:
				get_parent().change_state("DepressiveThoughts")
			3:
				get_parent().change_state("Barrage")
			4:
				get_parent().change_state("DestructiveThoughts")
				
