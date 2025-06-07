extends State

var can_transition: bool = false
func enter():
	super.enter()
	owner.attack_meter_animation.play("ultimate_anger")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#animation_player.play("raise_hand")
	owner.room_change_player.play("anger")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_animation.play("flash_screen")
	#animation_player.play("hand_down")
	owner.boss_room.change_stage_texture("anger")
	await owner.enrage_animation.animation_finished
	
	owner.smoke_1.play("smoke")
	owner.smoke_2.play("smoke")
	owner.smoke_3.play("smoke")
	owner.smoke_4.play("smoke")
	owner.smoke_5.play("smoke")
	owner.smoke_6.play("smoke")
	owner.smoke_7.play("smoke")
	owner.smoke_8.play("smoke")
	owner.smoke_9.play("smoke")
	owner.smoke_10.play("smoke")
	owner.smoke_11.play("smoke")
	owner.smoke_12.play("smoke")
	owner.smoke_13.play("smoke")
	owner.smoke_14.play("smoke")
	owner.smoke_15.play("smoke")
	owner.smoke_16.play("smoke")
	
	owner.boss_1_animation.play("sword_drop")
	await owner.boss_1_animation.animation_finished
		
	owner.boss_1_animation.play("explosions")
	
	for i in range(7):
		#player.beam_circle_meteor()
		#owner.boss_room_animation.play("meteor")
		owner.attack_meter_animation.play("meteor")
		await get_tree().create_timer(2.4988).timeout
		animation_player.play("attack")
		if player.global_position.x - owner.global_position.x > 0:
			owner.sprite.flip_h = false
		else:
			owner.sprite.flip_h = true
		#await get_tree().create_timer(0.5).timeout
		await owner.attack_meter_animation.animation_finished
		#owner.beam_circle()
		owner.meteor.closest_square_position(player.position)
	
	await owner.boss_1_animation.animation_finished
	owner.attack_meter_animation.play("knockback")
	await get_tree().create_timer(1.5).timeout
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	animation_player.play("attack")
	await owner.attack_meter_animation.animation_finished
	owner.camera_shake()
	owner.knockback_effect_anger.play("knockback_effect")
	owner.knockback_audio.play()
	apply_knockback()
	await get_tree().create_timer(2).timeout
	can_transition = true
	
func apply_knockback():
	if player:
		player.apply_knockback(owner.center_of_screen + Vector2(240, 135), 350) #350
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("UltimateBargain") #AttackCombo
