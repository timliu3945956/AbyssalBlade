extends State

var can_transition: bool = false
var direction = randi_range(1, 2)

func enter():
	super.enter()
	owner.attack_meter_animation.play("ultimate_bargain")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#animation_player.play("raise_hand")
	owner.room_change_player.play("bargain")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_animation.play("flash_screen")
	#animation_player.play("hand_down")
	owner.meteor.queue_free()
	owner.boss_room.change_stage_texture("bargain")
	await owner.enrage_animation.animation_finished
	
	if direction == 1:
		owner.boss_room.spawn_special_counterclockwise()
	else:
		owner.boss_room.spawn_special_clockwise()
	#await get_tree().create_timer(5, true, false, false).timeout
	await TimeWait.wait_sec(5)
	
	owner.boss_2_animation.play("expanding_circles")
	await TimeWait.wait_sec(0.5) #await get_tree().create_timer(0.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#await get_tree().create_timer(4).timeout
	await owner.boss_2_animation.animation_finished
	
	owner.boss_2_animation.play("expanding_circles")
	await TimeWait.wait_sec(0.5) #await get_tree().create_timer(0.5).timeout
	animation_player.play("attack")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#await get_tree().create_timer(4).timeout
	await owner.boss_2_animation.animation_finished
	await TimeWait.wait_sec(2) #await get_tree().create_timer(2).timeout
	
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("UltimateDepression") #AttackCombo
