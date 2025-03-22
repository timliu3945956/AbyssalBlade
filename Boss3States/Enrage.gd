extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("enrage")
	await get_tree().create_timer(14.5).timeout
	animation_player.play("barrage")
	await owner.attack_meter_animation.animation_finished
	owner.sword_animation_player.play("enrage_swords")
	owner.boss_room_animation.play("wreak_havoc_red")
	#phase2 anim
	can_transition = true
	
#func transition():
	#if can_transition:
		#can_transition = false
		#
		#
