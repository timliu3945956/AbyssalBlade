extends State

var ForetoldTelegraph = preload("res://Other/ForetoldMelee.tscn")
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	#if owner.foretold_count == 2:
		#var move_boss = get_tree().create_tween()
		#move_boss.tween_property(owner, "position", owner.center_of_arena + Vector2(0, -50), 0.25) #0.4 seconds before change
	#owner.direction = (owner.center_of_screen + Vector2(-50, 0)) - owner.position
	#animation_player.play("disappear")
	##owner.smoke.play("smoke")
	#await get_tree().create_timer(0.6).timeout
	#
	#animation_player.play("appear")
	##owner.smoke.play("smoke")
	#if owner.pick_foretold == 1:
		#owner.position = owner.center_of_screen + Vector2(-50, 0)
	#else:
		#owner.position = owner.center_of_screen + Vector2(50, 0)
		#
	#if (owner.center_of_screen + Vector2(0, -100)).x - owner.position.x > 0:
		#owner.sprite.flip_h = false
		#owner.sprite_shadow.flip_h = false
	#else:
		#owner.sprite.flip_h = true
		#owner.sprite_shadow.flip_h = true
	#
	#await animation_player.animation_finished
	
	#await get_tree().create_timer(1).timeout
	if owner.foretold_count == 2:
		owner.attack_meter_animation.play("foretold_melee")
	else:
		owner.attack_meter_animation.play("foretold")
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await get_tree().create_timer(4.5).timeout
	animation_player.play("foretold")
	foretold_melee()
	await animation_player.animation_finished
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_left")
	else:
		animation_player.play("idle_right")
	await get_tree().create_timer(0.4167).timeout # extra await for attack animation
	if owner.foretold_count == 2:
		await get_tree().create_timer(2).timeout
	#if (owner.center_of_screen + Vector2(-50, 0)).x - owner.position.x > 0:
		#animation_player.play("walk_right")
	#else:
		#animation_player.play("walk_left")
		#
	#if owner.balance_counter != 2:
		#var move_boss = get_tree().create_tween()
		#move_boss.tween_property(owner, "position", (owner.center_of_screen + Vector2(-50, 0)), 1.5)
		#await get_tree().create_timer(1.5).timeout
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
