extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("debuff")
	owner.state_machine.travel("charge_hope_start")
	await owner.attack_meter_animation.animation_finished
	owner.state_machine.travel("charge_hope_finish")
	player.spawn_debuffs()
	player.debuff_bar.debuff_finished.connect(owner.boss_room._on_debuff_finished)
	
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2, Timer.TIMER_PROCESS_PHYSICS).timeout
	owner.debuff_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.debuff_count == 1:
			get_parent().change_state("Plunge")
		else:
			get_parent().change_state("GoldCloneSpawn")
