extends State

var center_of_screen = get_viewport_rect().size / 2 
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = center_of_screen - owner.position
	owner.animation_tree.set("parameters/Walk/blend_position", owner.direction)
	owner.state_machine.travel("Walk")
	if owner.direction.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")
	#if owner.direction.x > 0:
		#animation_player.play("idle_right")
	#else:
		#animation_player.play("idle_left")
	#animation_player.play("teleport_out")
	#await get_tree().create_timer(0.3332).timeout
	#smoke.play("smoke")
	#await smoke.animation_finished
	#
	#owner.position = center_of_screen
	#
	#smoke.play("smoke")
	#animation_player.play("teleport_in")
	##await animation_player.animation_finished
	#await smoke.animation_finished
	if (center_of_screen - owner.position).length() <= 2:
		can_transition = true
		owner.walk_center_count += 1
		
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if can_transition:
		can_transition = false
		match owner.walk_center_count:
			1:
				get_parent().change_state("Oblivion")
			2:
				get_parent().change_state("Vanquish")
			3:
				get_parent().change_state("Oblivion")
			4:
				get_parent().change_state("Oblivion")
	else:
		enter()
