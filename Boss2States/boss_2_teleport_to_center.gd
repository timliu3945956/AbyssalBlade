extends State
@onready var smoke: AnimatedSprite2D = $"../../smoke"

var center_of_screen = get_viewport_rect().size / 2 

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	if owner.direction.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	#animation_player.play("teleport_out")
	await TimeWait.wait_sec(0.3332)#await get_tree().create_timer(0.3332).timeout
	#smoke.play("smoke")
	#await smoke.animation_finished
	animation_player.play("disappear")
	owner.smoke.play("smoke")
	await TimeWait.wait_sec(0.6)#await get_tree().create_timer(0.6).timeout
	owner.position = center_of_screen
	
	animation_player.play("appear")
	owner.smoke.play("smoke")
	#smoke.play("smoke")
	#animation_player.play("teleport_in")
	#await animation_player.animation_finished
	#await smoke.animation_finished
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	if owner.boss_death == false:
		can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if can_transition:
	#var distance = owner.direction.length()
		can_transition = false
		if owner.timeline == 1:
			owner.timeline += 1
			get_parent().change_state("LineAOE")
		elif owner.timeline == 3:
			owner.timeline += 1
			get_parent().change_state("ComboSurge")
		elif owner.timeline == 4:
			owner.timeline += 1
			get_parent().change_state("Enrage")
			
	#elif (owner.center_of_screen - owner.position).length() <= 1 and owner.timeline == 1:
		#get_parent().change_state("InOutAttack")
