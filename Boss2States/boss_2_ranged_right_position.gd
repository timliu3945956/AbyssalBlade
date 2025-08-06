extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	
	if owner.jump_position_count == 0:
		owner.position = owner.center_of_screen + Vector2(-75, 0)
	else:
		owner.position = owner.center_of_screen + Vector2(75, 0)
	animation_player.play("jump_land")
	await animation_player.animation_finished
	
	if owner.jump_position_count == 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	await TimeWait.wait_sec(0.5833)#await get_tree().create_timer(0.5833).timeout
	owner.jump_position_count += 1
	can_transition = true

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("DarknessBalance")
