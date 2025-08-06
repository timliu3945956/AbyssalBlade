extends State

var ForetoldTelegraph = preload("res://Other/ForetoldMelee.tscn")
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	if owner.foretold_count == 2:
		owner.attack_meter_animation.play("foretold_melee")
	else:
		owner.attack_meter_animation.play("foretold")
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await TimeWait.wait_sec(4.5)#await get_tree().create_timer(4.5).timeout
	animation_player.play("foretold")
	foretold_melee()
	await animation_player.animation_finished
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await TimeWait.wait_sec(0.4167)#await get_tree().create_timer(0.4167).timeout # extra await for attack animation
	if owner.foretold_count == 2:
		await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func foretold_melee():
	var melee_attack = ForetoldTelegraph.instantiate()
	#melee_attack.position = position
	add_child(melee_attack)

func transition():
	if can_transition:
		can_transition = false
		if owner.foretold_count == 0:
			owner.foretold_count += 1
			get_parent().change_state("AutoAttack")
		elif owner.foretold_count == 1:
			owner.foretold_count += 1
			get_parent().change_state("AutoAttack")
		elif owner.foretold_count == 2:
			owner.foretold_count += 1
			animation_player.play("jump_away")
