extends State
var ForetoldTelegraph = preload("res://Other/ForetoldRanged.tscn")

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	if owner.foretold_count == 1:
		owner.attack_meter_animation.play("foretold_ranged")
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await TimeWait.wait_sec(4.5)#await get_tree().create_timer(4.5).timeout
	animation_player.play("special_stomp")
	foretold_ranged()
	await animation_player.animation_finished
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await TimeWait.wait_sec(0.4167)#await get_tree().create_timer(0.4167).timeout # extra await for attack animation
	
	can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func foretold_ranged():
	var ranged_attack = ForetoldTelegraph.instantiate()
	#ranged_attack.position = position
	add_child(ranged_attack)

func transition():
	if can_transition:
		can_transition = false
		if owner.foretold_count == 0:
			owner.foretold_count += 1
			get_parent().change_state("AutoAttack")
		elif owner.foretold_count == 1:
			owner.foretold_count += 1
			animation_player.play("jump_away")
		elif owner.foretold_count == 2:
			owner.foretold_count += 1
			get_parent().change_state("AutoAttack")
			#get_parent().change_state("JumpPosition")
