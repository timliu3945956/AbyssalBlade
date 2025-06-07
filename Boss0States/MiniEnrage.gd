extends State

var can_transition: bool = false

func enter():
	super.enter()
	
	#enrage animation here
	animation_player.play("mini_enrage")
	owner.enrage_fire_pop.emitting = true
	await get_tree().create_timer(0.4998).timeout
	#owner.chromatic_abberation_animation.play("chromatic_abberation")
	owner.enrage_background.play("background_change")
	await owner.enrage_background.animation_finished
	#await animation_player.animation_finished
	animation_player.play("idle_right")
	await get_tree().create_timer(1.5).timeout
	#await animation_player.animation_finished
	owner.enrage_fire_pop.emitting = false
	owner.spit_enrage = true
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
		
