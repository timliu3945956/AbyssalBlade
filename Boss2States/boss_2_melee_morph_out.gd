extends State
#@onready var morph_vfx: AnimatedSprite2D = $"../../MorphVFX"
@onready var morph_vfx_2: AnimatedSprite2D = $"../../MorphVFX2"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.morph_animation.play("morph_out")
	owner.boss_2_main.spawn_phase_particles()
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", owner.center_of_screen, 1.0)
	#await get_tree().create_timer(0.8333).timeout
	
	owner.emit_signal("mini_bosses_finished")
	owner.enrage_background.play("background_change_final")
	owner.morph_together_health()
	
	#await owner.attack_meter_animation.animation_finished
	
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", owner.center_of_screen, 1.0)
	#await get_tree().create_timer(0.8333).timeout
	#
	#owner.screen_animation.play("screen_light")
	#await get_tree().create_timer(0.1667).timeout
	#owner.enrage_background.play("background_change_final")
	#owner.morph_animation.play("morph_out")
	#owner.morph_together_health()
	#owner.emit_signal("mini_bosses_finished")
	
	#await get_tree().create_timer(0.25).timeout
	#await owner.morph_animation.animation_finished
	#can_transition = true
	##
		
#func transition():
	#if owner.paused:
		#return
