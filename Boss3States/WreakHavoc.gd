extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("wreak_havoc")
	if owner.crown_color == "white":
		owner.boss_room.white_telegraph_start()
		await TimeWait.wait_sec(2.1667)#await get_tree().create_timer(2.1667).timeout
		animation_player.play("windup")
		await animation_player.animation_finished
		#await get_tree().create_timer(2.5).timeout
		owner.boss_room.white_telegraph_end()
		await TimeWait.wait_sec(0.3)#await get_tree().create_timer(0.3).timeout
		owner.unleash_crown_audio.play()
	else:
		owner.boss_room.black_telegraph_start()
		await TimeWait.wait_sec(2.1667)#await get_tree().create_timer(2.1667).timeout
		animation_player.play("windup")
		await animation_player.animation_finished
		#await get_tree().create_timer(2.5).timeout
		
		owner.boss_room.black_telegraph_end()
		await TimeWait.wait_sec(0.3)#await get_tree().create_timer(0.3).timeout
		owner.unleash_crown_audio.play()
	await owner.attack_meter_animation.animation_finished
	
	print("gets here beofre it stops working")
	if owner.crown_color == "white":
		owner.white_crown.modulate.a = 0
		owner.white_crown_expand.modulate.a = 0
		owner.crown_color = "white"
		owner.crown_aura_white.modulate.a = 0
		owner.crown_aura_white.stop()
	else:
		owner.black_crown.modulate.a = 0
		owner.black_crown_expand.modulate.a = 0
		owner.crown_color = "black"
		owner.crown_aura_black.modulate.a = 0
		owner.crown_aura_black.stop()
	animation_player.play("oppressive")
	if owner.crown_color == "white":
		owner.boss_room_animation.play("wreak_havoc_white")
		await owner.boss_room_animation.animation_finished
	else:
		owner.boss_room_animation.play("wreak_havoc_black")
		await owner.boss_room_animation.animation_finished
	
	
	animation_player.play("standup")
	await animation_player.animation_finished
	
	owner.wreak_havoc_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.wreak_havoc_count == 1:
			get_parent().change_state("ExistentialCrisis")
		else:
			get_parent().change_state("Barrage")
