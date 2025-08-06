extends State

var can_transition: bool = false

var cycles = 4
var wind_up_time = 2.0
var exit_delay:= 25
var pick_random = randi_range(1, 2)

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	randomize()
	owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	owner.state_machine.travel("Idle")
	owner.attack_meter_animation.play("plunge")
	await owner.attack_meter_animation.animation_finished
	#if pick_random == 1:
	owner.sword_fade_animation.play("sword_fade_in_start")
	owner.sword_animation_player.play("sword_in_appear")
	owner.plunge_telegraph_animation.play("plunge_in_telegraph")
	await TimeWait.wait_sec(1.9)#await get_tree().create_timer(1.9, false, true).timeout
	
	for i in cycles:
		owner.ravage_audio.play()
		await TimeWait.wait_sec(0.095)#await get_tree().create_timer(0.07, false, true).timeout
		owner.boss_room_animation.play("plunge_in_attack")
		owner.state_machine.travel("downattack_stand")
		
		var tween = get_tree().create_tween()
		tween.tween_property(
			owner.sword_marker_in,
			"rotation",
			owner.sword_marker_in.rotation + deg_to_rad(360), 
			0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
		var vfx_tween = get_tree().create_tween()
		vfx_tween.tween_property(
			owner.boss_room.plunge_in_marker,
			"rotation",
			owner.boss_room.plunge_in_marker.rotation + deg_to_rad(360),
			0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
		
		owner.sword_animation_player.play("sword_in_disappear")
		
		owner.sword_fade_animation.play("sword_fade_out_start")
		owner.sword_animation_player_2.play("sword_out_appear")
		owner.plunge_telegraph_animation.play("plunge_out_telegraph")
		
		await TimeWait.wait_sec(1.9)#await get_tree().create_timer(1.9, false, true).timeout
		owner.ravage_audio.play()
		await TimeWait.wait_sec(0.095)#await get_tree().create_timer(0.07, false, true).timeout
		
		owner.boss_room_animation.play("plunge_out_attack")
		#if i < 3:
			#owner.state_machine.travel("downattack_staydown_2")
		#else:
		owner.state_machine.travel("downattack_stand")
		tween = get_tree().create_tween()
		tween.tween_property(
			owner.sword_marker_out, 
			"rotation", 
			owner.sword_marker_out.rotation + deg_to_rad(360), 
			0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
		vfx_tween = get_tree().create_tween()
		vfx_tween.tween_property(
			owner.boss_room.plunge_out_marker,
			"rotation",
			owner.boss_room.plunge_out_marker.rotation + deg_to_rad(360),
			0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
		owner.sword_animation_player_2.play("sword_out_disappear")
		if i < 3:
			owner.sword_fade_animation.play("sword_fade_in_start")
			owner.sword_animation_player.play("sword_in_appear")
			owner.plunge_telegraph_animation.play("plunge_in_telegraph")
			await TimeWait.wait_sec(1.9)#await get_tree().create_timer(1.9, false, true).timeout
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("AttackCombo")
