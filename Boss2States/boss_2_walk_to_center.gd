extends State

var center_walk: int = 0
var can_transition = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	#owner.set_physics_process(true)
	#owner.direction = owner.center_of_screen - owner.position
	animation_player.play("disappear")
	owner.smoke.play("smoke")
	await TimeWait.wait_sec(0.6)#await get_tree().create_timer(0.6).timeout
	
	animation_player.play("appear")
	owner.smoke.play("smoke")
	owner.position = owner.center_of_screen
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", (owner.center_of_screen), 0.5)
	#animation_player.play("dash_start")
	if (owner.center_of_screen + Vector2(0, -100)).x - owner.position.x > 0:
		owner.sprite.flip_h = false
		owner.sprite_shadow.flip_h = false
	else:
		owner.sprite.flip_h = true
		owner.sprite_shadow.flip_h = true
	await animation_player.animation_finished
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", (owner.center_of_screen), 0.5)
	#animation_player.play("dash_start")
	#if (owner.center_of_screen + Vector2(0, -100)).x - owner.position.x > 0:
		#owner.sprite.flip_h = false
		#owner.sprite_shadow.flip_h = false
	#else:
		#owner.sprite.flip_h = true
		#owner.sprite_shadow.flip_h = true
	#await get_tree().create_timer(0.25).timeout
	#animation_player.play("dash_stop")
	#await get_tree().create_timer(0.25).timeout
	if owner.boss_death == false:
		can_transition = true
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	#var distance = owner.direction.length()
	if can_transition:
	#if distance < 2:
		can_transition = false
		owner.walk_center_count += 1
		#if owner.walk_center_count == 1:
		get_parent().change_state("MorphOut")
		#elif owner.walk_center_count == 2:
			#get_parent().change_state("MorphOut")
		#elif owner.walk_center_count == 2:
			#get_parent().change_state("Enrage")
	#else:
		#enter()
