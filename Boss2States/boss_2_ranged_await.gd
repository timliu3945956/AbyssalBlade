extends State

var can_transition = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	
	animation_player.play("fade_out")
	await TimeWait.wait_sec(22.3335)#await get_tree().create_timer(22.3335).timeout
	animation_player.play("fade_in")
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("AutoAttack")
