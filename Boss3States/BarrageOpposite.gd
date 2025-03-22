extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	
	animation_player.play("idle")
	owner.black_smoke_symbol_anim.play("default")
	owner.attack_meter_animation.play("barrage")
	if owner.barrage_count % 2 == 0:
		owner.barrage_symbol_animation.play("barrage_1")
	else:
		owner.barrage_symbol_animation.play("barrage_2")
	await owner.attack_meter_animation.animation_finished
	
	if owner.barrage_count % 2 == 0: #In -> out -> plus
		if owner.crown_color == "white":
			owner.boss_room_animation.play("barrage_black_1")
			await owner.boss_room_animation.animation_finished
		else:
			owner.boss_room_animation.play("barrage_white_1")
			await owner.boss_room_animation.animation_finished
	else:
		if owner.crown_color == "white":
			owner.boss_room_animation.play("barrage_black_2")
			await owner.boss_room_animation.animation_finished
		else:
			owner.boss_room_animation.play("barrage_white_2")
			await owner.boss_room_animation.animation_finished
			
	#var red_sword_tween = get_tree().create_tween()
	var white_sword_tween = get_tree().create_tween()
	var black_sword_tween = get_tree().create_tween()
	#red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.5)
	white_sword_tween.tween_property(owner.white_swords, "modulate:a", 0, 0.5)
	black_sword_tween.tween_property(owner.black_swords, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	owner.barrage_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("WreakHavoc")
