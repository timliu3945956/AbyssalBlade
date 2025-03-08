extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = owner.center_of_screen - owner.position
	
	if owner.direction.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")
	can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	const states = ["CleaveCharge1", "CleaveCharge2", "DodgeShadowClone", "Cleave1", "ShadowClone", "Cleave2", "CleaveCharge1", "CleaveCharge2",
		"DodgeShadowCloneCombo", "Cleave1", "ShadowCloneCombo", "Cleave2", "Enrage"]
	# timeline in boss0 is based off of how many times 2 slashes goes out and follows to center
	if (owner.center_of_screen - owner.position).length() <= 2:
		owner.timeline += 1
		get_parent().change_state(states[owner.timeline])
