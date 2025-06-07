extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false
var LaserBeam = preload("res://Other/beam_dodge.tscn")
var red_sword_tween: Tween
	#"res://Characters/beam.tscn")
#var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
#@onready var beam_circle_timer: Timer = $"../../BeamCircleTimer"
#var circle_ref: Node2D
var barrage_random_1: int = randi_range(1, 2)
var barrage_random_2: int = randi_range(1, 2)


func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	barrage_random_1 = randi_range(1, 2)
	barrage_random_2 = randi_range(1, 2)
	animation_player.play("RESET")
	owner.sword_animation_player.play("RESET")
	
	set_process_input(true)
	animation_player.play("idle")
	owner.sword_animation_player.play("swords_idle")
	
	print("seeing what this equals: ", int(0 / 2))
	owner.black_smoke_symbol_anim.play("default")
	var tween = get_tree().create_tween()
	tween.tween_property(owner.black_smoke_symbol_anim, "self_modulate:a", 1, 0.3)
	owner.attack_meter_animation.play("barrage")
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.3)
	if barrage_random_1 == 1:
		owner.barrage_symbol_animation.play("barrage_in")
	else:
		owner.barrage_symbol_animation.play("barrage_out")
	await owner.barrage_symbol_animation.animation_finished
	if barrage_random_2 == 1:
		owner.barrage_symbol_animation.play("barrage_in")
	else:
		owner.barrage_symbol_animation.play("barrage_out")
	await owner.barrage_symbol_animation.animation_finished
	
	if owner.barrage_third_pick == 1:
		if owner.barrage_count % 2 == 0:
			owner.barrage_symbol_animation.play("barrage_+")
		else:
			owner.barrage_symbol_animation.play("barrage_x")
	else:
		if owner.barrage_count % 2 == 0:
			owner.barrage_symbol_animation.play("barrage_x")
		else:
			owner.barrage_symbol_animation.play("barrage_+")
	await get_tree().create_timer(1.5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(owner.black_smoke_symbol_anim, "self_modulate:a", 0, 0.5)
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
	
	animation_player.play("barrage")
	await get_tree().create_timer(0.35).timeout
	owner.barrage_audio.play()
	await owner.barrage_symbol_animation.animation_finished
	
	
	if barrage_random_1 == 1:
		owner.boss_room_animation.play("barrage_in")
	else:
		owner.boss_room_animation.play("barrage_out")
	await get_tree().create_timer(1.5).timeout
	
	animation_player.play("barrage")
	await get_tree().create_timer(0.35).timeout
	owner.barrage_audio.play()
	await owner.boss_room_animation.animation_finished
	
	if barrage_random_2 == 1:
		owner.boss_room_animation2.play("barrage_in")
	else:
		owner.boss_room_animation2.play("barrage_out")
	await get_tree().create_timer(1.5).timeout
	
	animation_player.play("barrage")
	await get_tree().create_timer(0.35).timeout
	owner.barrage_audio.play()
	await owner.boss_room_animation2.animation_finished
	
	if owner.barrage_third_pick == 1:
		if owner.barrage_count % 2 == 0:
			owner.boss_room_animation.play("barrage_+")
		else:
			owner.boss_room_animation.play("barrage_x")
	else:
		if owner.barrage_count % 2 == 0:
			owner.boss_room_animation.play("barrage_x")
		else:
			owner.boss_room_animation.play("barrage_+")
	await get_tree().create_timer(1.5).timeout
	
	owner.barrage_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Oppressive")
