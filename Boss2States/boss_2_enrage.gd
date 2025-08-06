extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	animation_player.play("idle_right")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.attack_meter_animation.play("enrage")
	# Play animation here
	
	await TimeWait.wait_sec(9.496)#await get_tree().create_timer(9.496).timeout
	animation_player.play("enrage_attack")
	await owner.attack_meter_animation.animation_finished
	if owner.boss_death == false:
		owner.boss_room.enrage_attack()
		owner.player.kill_player()
