extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	await get_tree().create_timer(10).timeout
		
#func transition():
	#if owner.paused:
		#return
