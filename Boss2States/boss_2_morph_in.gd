extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	# Charge up of laser beam (cast bar)
	#await get_tree().create_timer(2).timeout
	##laser beam in between
	#await get_tree().create_timer(2).timeout
	animation_player.play("morph_in")
	await animation_player.animation_finished
	owner.enrage_fire.emitting = true
	owner.enrage_fire.visible = true
	owner.enrage_fire_pop.emitting = true
	#owner.paused = false
	owner.enraged = true
	animation_player.play("idle_right")
	await get_tree().create_timer(1).timeout
	
	owner.attack_meter_animation.play("malice")
	await get_tree().create_timer(2.25).timeout
	animation_player.play("buff")
	await owner.attack_meter_animation.animation_finished
	await get_tree().create_timer(0.1667).timeout
	owner.boss_attack_animation_2.play("malice")
	animation_player.play("idle_right")
	await get_tree().create_timer(1.5).timeout # instead of 2, 1.5 await
	if owner.boss_death == false:
		can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Beam")
