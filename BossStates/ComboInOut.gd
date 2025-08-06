extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	var choose_in_out = randi_range(1, 2)
	animation_player.play("idle_right")
	match choose_in_out:
		1:
			owner.boss_room_animation.play("attack_in_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
			await owner.boss_room_animation.animation_finished
			owner.boss_room_animation.play("attack_out_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
			await owner.boss_room_animation.animation_finished
			owner.boss_room_animation.play("attack_in_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
		2:
			owner.boss_room_animation.play("attack_out_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
			await owner.boss_room_animation.animation_finished
			owner.boss_room_animation.play("attack_in_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
			await owner.boss_room_animation.animation_finished
			owner.boss_room_animation.play("attack_out_combo")
			await TimeWait.wait_sec(1.1662)#await get_tree().create_timer(1.1662).timeout
			animation_player.play("alternate_slam")
			
	#await owner.boss_room_animation.animation_finished
	await animation_player.animation_finished
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
