extends State

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("enrage")
	await owner.boss_charge_animation.animation_finished
	#await animation_player.animation_finished
	animation_player.play("buff_attack")
	await get_tree().create_timer(0.4998).timeout
	owner.enrage_fire.emitting = true
	
	owner.boss_room_animation.play("arena_aoe")
	await owner.boss_room_animation.animation_finished
	#can_transition = true
	
#func transition():
	#if can_transition:
		#can_transition = falsef
		#get_parent().change_state()
		
