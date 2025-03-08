extends State

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("main_boss_morph")
	#owner.morph_vfx.play("default")
	owner.morph_vfx_2.play("default")
	animation_player.play("morph_out")
	await get_tree().create_timer(4.75).timeout
	owner.morph_apart_health()
	owner.screen_animation.play("screen_light")
	await get_tree().create_timer(0.25).timeout
	owner.enrage_background.play("background_change")
	#await get_tree().create_timer(0.25).timeout
	owner.emit_signal("main_boss_finished")
	
	await owner.attack_meter_animation.animation_finished
	await get_tree().create_timer(0.5).timeout
	
	#animation_player.play("morph_out")
	#await animation_player.animation_finished
	
	#owner.morph_apart_health()
	#owner.emit_signal("main_boss_finished")
	
#func transition():
	#if owner.paused:
		#return
		
		
	#else:
		#can_transition = true
	#if can_transition:
		#can_transition = false
		#get_parent().change_state("MorphIn")
