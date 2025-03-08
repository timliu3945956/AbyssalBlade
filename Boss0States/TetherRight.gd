extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("idle_right")
	
	owner.boss_charge_animation.play("charge_cleave")
	#owner.tether_animation_player.play("tether_right")
	owner.boss_clone_animation.play("clone_right")
	await owner.boss_clone_animation.animation_finished
	#owner.boss_clone_animation_2.play("idle")
	can_transition = true
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("MoveToCenter")
