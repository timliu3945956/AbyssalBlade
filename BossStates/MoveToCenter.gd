extends State
@onready var smoke: AnimatedSprite2D = $"../../smoke"

var center_of_screen = get_viewport_rect().size / 2 

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	
	if owner.direction.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")
	#if owner.direction.x > 0:
		#animation_player.play("idle_right")
	#else:
		#animation_player.play("idle_left")
	#animation_player.play("teleport_out")
	#await get_tree().create_timer(0.3332).timeout
	#smoke.play("smoke")
	#await smoke.animation_finished
	#
	#owner.position = center_of_screen
	#
	#smoke.play("smoke")
	#animation_player.play("teleport_in")
	##await animation_player.animation_finished
	#await smoke.animation_finished
	if (owner.center_of_screen - owner.position).length() <= 2:
		can_transition = true
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if can_transition:
	#var distance = owner.direction.length()
		can_transition = false
		#if (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 15:
			#get_parent().change_state("Enrage")
		#elif (owner.center_of_screen - owner.position).length() <= 1 and owner.timeline == 14:
			#get_parent().change_state("Explosions")
		if (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 17:
			get_parent().change_state("Enrage")
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 15:
			get_parent().change_state("Explosions")
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 13:
			get_parent().change_state("AlternateComboAttack")
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 11:
			get_parent().change_state("Explosions") # enrage turned on here
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 9:
			get_parent().change_state("ComboKnockback")
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 5:
			get_parent().change_state("AlternateAttack")
		elif (owner.center_of_screen - owner.position).length() <= 2 and owner.timeline == 3:
			get_parent().change_state("KnockbackInOutAttack")
	else:
		enter()
	#elif (owner.center_of_screen - owner.position).length() <= 1 and owner.timeline == 1:
		#get_parent().change_state("InOutAttack")
