extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("surge")
	await get_tree().create_timer(2.5).timeout
	animation_player.play("barrage")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_background.play("background_change")
	#phase2 anim
	await get_tree().create_timer(0.5).timeout
	can_transition = true #phase 2 changes
	
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Devour")
