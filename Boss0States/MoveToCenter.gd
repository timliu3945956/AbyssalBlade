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
	# timeline in boss0 is based off of how many times 2 slashes goes out and follows to center
	if (owner.center_of_screen - owner.position).length() <= 2:
		match owner.timeline:
			0:
				owner.timeline += 1
				get_parent().change_state("CleaveCharge1")
			1:
				owner.timeline += 1
				get_parent().change_state("CleaveCharge2")
			2:
				owner.timeline += 1
				get_parent().change_state("DodgeShadowClone")
			3:
				owner.timeline += 1
				get_parent().change_state("Cleave1")
			4:
				owner.timeline += 1
				get_parent().change_state("ShadowClone")
			5:
				owner.timeline += 1
				get_parent().change_state("Cleave2")
			6:
				owner.timeline += 1
				get_parent().change_state("CleaveCharge1")
			7:
				owner.timeline += 1
				get_parent().change_state("CleaveCharge2")
			8:
				owner.timeline += 1
				get_parent().change_state("DodgeShadowCloneCombo")
			9:
				owner.timeline += 1
				get_parent().change_state("Cleave1")
			10:
				owner.timeline += 1
				get_parent().change_state("ShadowCloneCombo")
			11:
				owner.timeline += 1
				get_parent().change_state("Cleave2")
			12:
				owner.timeline += 1
				get_parent().change_state("Enrage")
