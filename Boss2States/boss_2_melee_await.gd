extends State

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = (Vector2(0, -80)) - owner.position
	
	if owner.direction.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	
	if distance < 2:
		owner.direction = Vector2.ZERO
		animation_player.play("idle_right")
	else:
		enter()
