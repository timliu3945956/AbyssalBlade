extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.attack_meter_animation.play("hands_of_death")
	await owner.attack_meter_animation.animation_finished
	##
		
#func transition():
	#if owner.paused:
		#return
