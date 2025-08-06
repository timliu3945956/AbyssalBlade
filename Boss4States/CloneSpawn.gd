extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.attack_meter_animation.play("spawn_clone")
	owner.state_machine.travel("charge_hope_start")
	await owner.attack_meter_animation.animation_finished
	owner.state_machine.travel("charge_hope_finish")
	owner.boss_room.spawn_gold_clone()
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.gold_count += 1
	can_transition = true
	
	
func transition():
	if can_transition:
		can_transition = false
		if owner.gold_count == 1:
			get_parent().change_state("AttackCombo")
		elif owner.gold_count == 2:
			get_parent().change_state("WalkCenter")
		elif owner.gold_count == 3:
			get_parent().change_state("FatalEnd")
