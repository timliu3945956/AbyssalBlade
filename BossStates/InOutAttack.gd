extends State

var can_transition: bool = false

func enter():
	super.enter()
	
	owner.velocity = Vector2.ZERO
	var choose_in_out = randi_range(1, 2)
	animation_player.play("idle_right")
	match choose_in_out:
		1:
			owner.boss_room_animation.play("attack_in")
		2:
			owner.boss_room_animation.play("attack_out")
	
	#var charge_into_animation_length = animation_player.get_animation("charge_into").length
	#var charge_outof_animation_length = animation_player.get_animation("charge_outof").length
	#var animation_length = owner.boss_room_animation.get_animation("attack_out").length
	#
	#animation_player.play("charge_into")
	#await animation_player.animation_finished
#
	#animation_player.play("charge")
	#await get_tree().create_timer(animation_length-charge_into_animation_length-charge_outof_animation_length).timeout
#
	#animation_player.play("charge_outof")
	#await animation_player.animation_finished
	await get_tree().create_timer(2.1658).timeout
	animation_player.play("alternate_slam")
	#await owner.boss_room_animation.animation_finished
	await animation_player.animation_finished
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
