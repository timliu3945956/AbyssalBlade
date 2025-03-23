extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("wreak_havoc")
	await get_tree().create_timer(2.5).timeout
	owner.unleash_crown_audio.play()
	await owner.attack_meter_animation.animation_finished
	
	animation_player.play("oppressive")
	if owner.crown_color == "white":
		owner.boss_room_animation.play("wreak_havoc_white")
	else:
		owner.boss_room_animation.play("wreak_havoc_black")
	await owner.boss_room_animation.animation_finished
	
	animation_player.play("standup")
	if owner.crown_color == "white":
		var crown_tween = get_tree().create_tween()
		crown_tween.tween_property(owner.white_crown, "modulate:a", 0, 0.5)
		var white_crown_expand_tween = get_tree().create_tween()
		white_crown_expand_tween.tween_property(owner.white_crown_expand, "modulate:a", 0, 0.5)
		owner.crown_color = "white"
	else:
		var crown_tween = get_tree().create_tween()
		crown_tween.tween_property(owner.black_crown, "modulate:a", 0, 0.5)
		var black_crown_expand_tween = get_tree().create_tween()
		black_crown_expand_tween.tween_property(owner.black_crown_expand, "modulate:a", 0, 0.5)
		owner.crown_color = "black"
	await animation_player.animation_finished
	owner.wreak_havoc_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		if owner.wreak_havoc_count == 1:
			get_parent().change_state("ExistentialCrisis")
		else:
			get_parent().change_state("Devour")
