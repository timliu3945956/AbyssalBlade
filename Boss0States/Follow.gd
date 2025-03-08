extends State

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = player.position - owner.position
	
	if owner.direction.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	
	if distance < 50:
		get_parent().change_state("SpitAttack")
	else:
		enter()
