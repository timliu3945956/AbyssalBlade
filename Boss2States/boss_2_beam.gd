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
	if owner.cleave_count == 1:
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
		#owner.jump_audio.play()
		await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
		owner.dash_particles.emitting = false
	
	owner.attack_meter_animation.play("beam")
	if owner.to_local(player.global_position).x - owner.position.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout

	owner.telegraph_player.play("beam")
	owner.beam_rotation = player.global_position - global_position
	owner.beam_aim.rotation = owner.beam_aim.global_position.angle_to_point(player.global_position)
	if owner.to_local(player.global_position).x - owner.position.x > 0:
		owner.sprite.flip_h = false
		owner.sprite_shadow.flip_h = false
	else:
		owner.sprite.flip_h = true
		owner.sprite_shadow.flip_h = false
	#await get_tree().create_timer(0.5).timeout
	animation_player.play("beam")
	await TimeWait.wait_sec(0.45)#await get_tree().create_timer(0.45).timeout
	beam_audio.play()
	await TimeWait.wait_sec(0.05)#await get_tree().create_timer(0.05).timeout
	beam()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	
	owner.beam_count += 1
	if owner.boss_death == false:
		can_transition = true
	
func beam():
	var beam = LaserBeam.instantiate()
	beam.position = Vector2(0, -6)
	beam.rotation = (owner.beam_rotation).angle()
	add_child(beam)
	print("beam being instantiated")
	
func beam_circle():
	owner.circle_ref = owner.beam_bar.instantiate()
	#owner.beam_circle_timer.start()
	owner.circle_ref.position = owner.to_local(player.global_position)
	add_child(owner.circle_ref)

func transition():
	if can_transition:
		can_transition = false
		#match owner.beam_count:
			#1:
		get_parent().change_state("ForwardCleave")
			#2:
				#get_parent().change_state("Discharge")
			#3:
				#get_parent().change_state("ForwardCleave")
			#4:
				#get_parent().change_state("Discharge")
			
