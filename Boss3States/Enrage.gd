extends State

var can_transition: bool = false
var red_sword_tween: Tween
func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("enrage")
	owner.sword_animation_player.play("swords_idle")
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.3)
	await get_tree().create_timer(14.8).timeout
	
	await owner.attack_meter_animation.animation_finished
	animation_player.play("windup")
	await get_tree().create_timer(0.1333).timeout
	owner.unleash_crown_audio.play()
	await animation_player.animation_finished
	animation_player.play("oppressive")
	#owner.barrage_audio.play()
	owner.camera_shake()
	owner.sword_animation_player.play("enrage_swords")
	owner.boss_room_animation.play("wreak_havoc_red")
	#phase2 anim
	can_transition = true
	
#func transition():
	#if can_transition:
		#can_transition = false
		#
		#
