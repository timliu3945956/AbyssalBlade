extends State

var direction : Vector2
var can_transition = false

var pain_counter = 0

func enter():
	super.enter()
	
	animation_player.play("idle_right")
	owner.attack_meter_animation.play("hands_of_pain")
	owner.pain_line_timer()
	await owner.attack_meter_animation.animation_finished
	owner.hands_of_pain()
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if pain_counter == 0:
			pain_counter += 1
			get_parent().change_state("ExpandingCircle")
		elif pain_counter == 1:
			pain_counter += 1
			get_parent().change_state("MorphOut")
