extends State

var can_transition: bool = false
var phase_vfx = preload("res://Other/boss_2_phase_vfx.tscn")

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("main_boss_morph")
	start_phase_change_vfx()
	#owner.morph_vfx_2.play("default")
	animation_player.play("morph_out")
	await get_tree().create_timer(5).timeout
	owner.morph_apart_health()
	#owner.screen_animation.play("screen_light")
	await get_tree().create_timer(2).timeout
	owner.enrage_background.play("background_change")
	#await get_tree().create_timer(0.25).timeout
	owner.emit_signal("main_boss_finished")
	
	await owner.attack_meter_animation.animation_finished
	await get_tree().create_timer(0.5).timeout
	
	#animation_player.play("morph_out")
	#await animation_player.animation_finished
	
	#owner.morph_apart_health()
	#owner.emit_signal("main_boss_finished")
	
func start_phase_change_vfx():
	var vfx = phase_vfx.instantiate()
	vfx.position = Vector2(0, -8)
	add_child(vfx)
		
#func transition():
	#if owner.paused:
		#return
		
		
	#else:
		#can_transition = true
	#if can_transition:
		#can_transition = false
		#get_parent().change_state("MorphIn")
