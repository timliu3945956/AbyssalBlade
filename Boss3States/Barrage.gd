extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false
var LaserBeam = preload("res://Other/beam_dodge.tscn")
var red_sword_tween: Tween
	#"res://Characters/beam.tscn")
#var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
#@onready var beam_circle_timer: Timer = $"../../BeamCircleTimer"
#var circle_ref: Node2D


func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	animation_player.play("RESET")
	owner.sword_animation_player.play("RESET")
	set_process_input(true)
	animation_player.play("idle")
	owner.sword_animation_player.play("swords_idle")
	
	print("seeing what this equals: ", int(0 / 2))
	owner.black_smoke_symbol_anim.play("default")
	owner.attack_meter_animation.play("barrage")
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.5)
	if owner.barrage_count % 2 == 0:
		owner.barrage_symbol_animation.play("barrage_1")
	else:
		owner.barrage_symbol_animation.play("barrage_2")
	await get_tree().create_timer(5.5).timeout
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
	animation_player.play("barrage")
	await owner.attack_meter_animation.animation_finished
	
	if owner.barrage_count % 2 == 0: #In -> out -> plus
		owner.boss_room_animation.play("barrage_1")
	else:
		owner.boss_room_animation.play("barrage_2")
	await get_tree().create_timer(1.5).timeout
	animation_player.play("barrage")
	await get_tree().create_timer(2).timeout
	animation_player.play("barrage")
	await owner.boss_room_animation.animation_finished
			
	#red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.5)
	#await get_tree().create_timer(1).timeout
	owner.barrage_count += 1
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Oppressive")
