extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false
var LaserBeam = preload("res://Other/beam_dodge.tscn")
	#"res://Characters/beam.tscn")
#var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
#@onready var beam_circle_timer: Timer = $"../../BeamCircleTimer"
#var circle_ref: Node2D


func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	if owner.center_of_screen.x - owner.position.x > 0:
		owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_dashfinish.png")
	else:
		owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_dashfinish_flipped.png")
		
	owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 3)
	owner.dash_particles.emitting = true
	var move_position = owner.center_of_screen
	var tween = get_tree().create_tween()
	tween.tween_property(owner, "position", move_position, 0.5)
	animation_player.play("dash_stop")
	owner.dash_audio.play()
	owner.jump_audio.play()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	owner.dash_particles.emitting = false
	
	owner.attack_meter_animation.play("heartmind")
	animation_player.play("idle_right")
	await owner.attack_meter_animation.animation_finished
	animation_player.play("jump")
	await animation_player.animation_finished
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	
	owner.boss_attack_animation.play("expanding_circles")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	owner.boss_attack_animation_2.play("ranged_lines")
	await owner.boss_attack_animation.animation_finished
	owner.boss_attack_animation.play("expanding_circles")
	await owner.boss_attack_animation_2.animation_finished
	
	owner.boss_room.spawn_special_part_2(false, 450.0, 22.5)
	await TimeWait.wait_sec(13)#await get_tree().create_timer(13).timeout
	animation_player.play("slamdown")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.attack_meter_animation.play("malice")
	await TimeWait.wait_sec(2.25)#await get_tree().create_timer(2.25).timeout
	animation_player.play("buff")
	await owner.attack_meter_animation.animation_finished
	await TimeWait.wait_sec(0.1667)#await get_tree().create_timer(0.1667).timeout
	owner.boss_attack_animation_2.play("malice_reverse")
	animation_player.play("idle_right")
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	if owner.boss_death == false:
		can_transition = true	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Beam")
