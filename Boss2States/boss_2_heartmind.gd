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
	await get_tree().create_timer(0.5).timeout
	owner.dash_particles.emitting = false
	
	owner.attack_meter_animation.play("heartmind")
	animation_player.play("idle_right")
	await owner.attack_meter_animation.animation_finished
	animation_player.play("jump")
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	
	
	owner.boss_attack_animation.play("expanding_circles")
	await get_tree().create_timer(1).timeout
	owner.boss_attack_animation_2.play("ranged_lines")
	await owner.boss_attack_animation.animation_finished
	owner.boss_attack_animation.play("expanding_circles")
	await owner.boss_attack_animation_2.animation_finished
	
	owner.boss_room.spawn_special_part_2(false, 450.0, 22.5)
	await get_tree().create_timer(13).timeout
	animation_player.play("slamdown")
	await get_tree().create_timer(1).timeout
	
	owner.attack_meter_animation.play("malice")
	await get_tree().create_timer(2.25).timeout
	animation_player.play("buff")
	await owner.attack_meter_animation.animation_finished
	await get_tree().create_timer(0.1667).timeout
	owner.boss_attack_animation_2.play("malice_reverse")
	animation_player.play("idle_right")
	await get_tree().create_timer(2).timeout
	
	if owner.boss_death == false:
		can_transition = true
	
##

#func _process(delta):
	#if beam_circle_timer.time_left > 0:
		#circle_ref.position = player.position
#func _on_beam_timer_timeout() -> void:
	#var old_position = position
	#remove_child(owner.circle_ref)
	##boss_2.add_child(circle_ref)
	##circle_ref.global_position = old_global_pos
	#
	##get_tree().get_root().add_child(circle_ref)
	#var boss_room = get_node("../Boss2")
	#boss_room.add_child(circle_ref)
	#print(circle_ref.position)
	#circle_ref.position = old_position
	
func transition():
	if can_transition:
		can_transition = false
		#match owner.beam_count:
			#1:
		get_parent().change_state("Beam")
			#2:
				#get_parent().change_state("Discharge")
			#3:
				#get_parent().change_state("ForwardCleave")
			#4:
				#get_parent().change_state("Discharge")
			
