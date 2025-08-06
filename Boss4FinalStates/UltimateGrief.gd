extends State

func enter():
	super.enter()
	owner.attack_meter_animation.play("ultimate_grief")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#animation_player.play("raise_hand")
	owner.room_change_player.play("grief")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_animation.play("flash_screen")
	owner.boss_room.devour_circle_animation.play("circle_disappear")
	#animation_player.play("hand_down")
	owner.boss_shadow_animation.play("spawn_shadows")
	owner.boss_room.change_stage_texture("grief")
	await owner.enrage_animation.animation_finished
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.attack_meter_animation.play("enrage")
	owner.spawn_attack()
	owner.boss_shadow_animation.play("top_left_tether")
	await TimeWait.wait_sec(6.5)#await get_tree().create_timer(6.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.room_change_player.play("quad_1")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.boss_shadow_animation.play("top_right_tether")
	await TimeWait.wait_sec(6.5)#await get_tree().create_timer(6.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.room_change_player.play("quad_2")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.boss_shadow_animation.play("bottom_right_tether")
	await TimeWait.wait_sec(6.5)#await get_tree().create_timer(6.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.room_change_player.play("quad_3")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.boss_shadow_animation.play("bottom_left_tether")
	await TimeWait.wait_sec(6.5)#await get_tree().create_timer(6.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.room_change_player.play("quad_4")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.boss_shadow_animation.play("mid_tether")
	owner.final_attack_aura.play("default")
	await TimeWait.wait_sec(6.5)#await get_tree().create_timer(6.35).timeout
	animation_player.play("attack")
	await TimeWait.wait_sec(0.15)#await get_tree().create_timer(0.15).timeout
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.room_change_player.play("quad_mid")
	var tween = get_tree().create_tween()
	tween.tween_property(owner.sprite_shadow, "modulate:a", 0, 0.5)
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(2).timeout
	
