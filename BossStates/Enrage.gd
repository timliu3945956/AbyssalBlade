extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	owner.boss_room_animation.play("chargeup_enrage")
	animation_player.play("idle_right")
	
	await TimeWait.wait_sec(19.167)#await get_tree().create_timer(19.0837).timeout
	animation_player.play("enrage_chargeup")
	await animation_player.animation_finished
	animation_player.play("enrage_attack")
	
	await TimeWait.wait_sec(0.2499)#await get_tree().create_timer(0.2499).timeout
	owner.in_out_animation_player.play("enrage_end")
	await animation_player.animation_finished
	
	animation_player.play("idle_right")
	#can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state()
