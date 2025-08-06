extends State

var can_transition: bool = false
var phase_vfx = preload("res://Other/boss_0_phase_vfx.tscn")

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("surge")
	#start_phase_change_vfx()
	await TimeWait.wait_sec(4.5)#await get_tree().create_timer(4.5).timeout
	animation_player.play("barrage")
	await owner.attack_meter_animation.animation_finished
	owner.camera_shake()
	owner.enrage_fire.emitting = true
	owner.enrage_fire_pop.emitting = true
	owner.enrage_background.play("background_change")
	#phase2 anim
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	can_transition = true #phase 2 changes
	
	
func start_phase_change_vfx():
	var vfx = phase_vfx.instantiate()
	vfx.position = Vector2(0, -15)
	add_child(vfx)
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Devour")
