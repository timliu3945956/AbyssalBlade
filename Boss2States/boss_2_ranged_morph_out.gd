extends State
#@onready var morph_vfx: AnimatedSprite2D = $"../../MorphVFX"
@onready var morph_vfx_2: AnimatedSprite2D = $"../../MorphVFX2"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.morph_animation.play("morph_out")
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", owner.center_of_screen, 1.0)
	await TimeWait.wait_sec(0.8333)#await get_tree().create_timer(0.8333).timeout
	
	#can_transition = true
	#
#func transition():
	#if can_transition:
		#can_transition = false
		#get_parent().change_state("AutoAttack")
		
#func transition():
	#if owner.paused:
		#return
