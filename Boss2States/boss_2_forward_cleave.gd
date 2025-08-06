extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var cleave_audio: AudioStreamPlayer2D = $"../../CleaveAudio"

var center_of_arena = get_viewport_rect().size / 2 
var last_chosen_index: int = -1
var radius = 80.0
var vertex_radius = 91.0
var move_position: Vector2
var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_physics_process(true)
	
	owner.attack_meter_animation.play("cleave")
	if owner.cleave_count % 2 == 0:
		owner.sprite.flip_h = false
		owner.sprite_shadow.flip_h = false
	else:
		owner.sprite.flip_h = true
		owner.sprite_shadow.flip_h = true
	animation_player.play("cleave_chargeup")
	await animation_player.animation_finished
	
	animation_player.play("cleave_charge")
	await TimeWait.wait_sec(2.25)#await get_tree().create_timer(2.25).timeout
	match owner.cleave_count:
		0:
			owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_swordraise_single.png")
			owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 1)
			owner.dash_particles.emitting = true
			move_position = (center_of_arena + Vector2(cos(deg_to_rad(-150)),sin(deg_to_rad(-150))) * vertex_radius)
			var tween = get_tree().create_tween()
			tween.tween_property(owner, "position", move_position, 0.5)
			
		1:
			owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_swordraise_single_flipped.png")
			owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 1)
			owner.dash_particles.emitting = true
			move_position = (center_of_arena + Vector2(cos(deg_to_rad(-30)),sin(deg_to_rad(-30))) * vertex_radius)
			var tween = get_tree().create_tween()
			tween.tween_property(owner, "position", move_position, 0.5)
		2:
			owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_swordraise_single.png")
			owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 1)
			owner.dash_particles.emitting = true
			move_position = (center_of_arena + Vector2(cos(deg_to_rad(-150)),sin(deg_to_rad(-150))) * vertex_radius)
			var tween = get_tree().create_tween()
			tween.tween_property(owner, "position", move_position, 0.5)
		3:
			owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_swordraise_single_flipped.png")
			owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 1)
			owner.dash_particles.emitting = true
			move_position = (center_of_arena + Vector2(cos(deg_to_rad(-30)),sin(deg_to_rad(-30))) * vertex_radius)
			var tween = get_tree().create_tween()
			tween.tween_property(owner, "position", move_position, 0.5)
			
	owner.dash_audio.play()
	#owner.jump_audio.play()
	
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout

	owner.dash_particles.emitting = false
	owner.cleave_rotate()
	owner.cleave_telegraph.play("cleave")
	await owner.cleave_telegraph.animation_finished
	
	if owner.boss_death == false:
		animation_player.play("cleave")
		owner.boss_attack_animation.play("cleave_anim")
		owner.attack_vfx_animation.play("cleave_vfx")
		owner.cleave_vfx()
		owner.camera_shake()
		cleave_audio.play()
		
		
		owner.cleave_count += 1
	if owner.boss_death == false:
		can_transition = true
	
func move_boss_to_opposite(player_position: Vector2, boss: Node2D):
	var angle_to_player = (player.position - center_of_arena).angle()
	var opposite_angle = angle_to_player + PI
	
	var target_position = center_of_arena + Vector2(
		cos(opposite_angle), 
		sin(opposite_angle)
	) * radius
	
	owner.position = target_position
	
	# tween is for boss dashing to location for cleave
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(boss, "position", target_position, 1.0)
	#await get_tree().create_timer(2).timeout
	
func move_boss_to_random_vertex(boss: Node2D):
	if owner.cleave_count % 2 == 0:
		var vertex_angles = [
			#deg_to_rad(-90),
			#deg_to_rad(150),
			deg_to_rad(210)
			#deg_to_rad(-30),
			#deg_to_rad(30)
			#deg_to_rad(90),
		]
		var random_index = randi() % vertex_angles.size()
		print(random_index)
		#while random_index == last_chosen_index:
			#random_index = randi() % vertex_angles.size()
		var chosen_angle = vertex_angles[random_index]
		print(chosen_angle)
		
		var target_position = center_of_arena + Vector2(
			cos(chosen_angle),
			sin(chosen_angle)
		) * vertex_radius
	
		owner.position = target_position
		last_chosen_index = random_index
	else:
		var vertex_angles = [
			#deg_to_rad(-90),
			
			deg_to_rad(-30)
			#deg_to_rad(30)
			#deg_to_rad(90),
		]
		var random_index = randi() % vertex_angles.size()
		print(random_index)
		#while random_index == last_chosen_index:
			#random_index = randi() % vertex_angles.size()
		var chosen_angle = vertex_angles[random_index]
		print(chosen_angle)
		
		var target_position = center_of_arena + Vector2(
			cos(chosen_angle),
			sin(chosen_angle)
		) * vertex_radius
		
		owner.position = target_position
		last_chosen_index = random_index
	

	
func exit():
	super.exit()
	set_physics_process(false)

func transition():
	if can_transition:
		can_transition = false
		match owner.cleave_count:
			1:
				get_parent().change_state("ChainTiles")
			2:
				get_parent().change_state("Discharge") #boss main up until here finished
			3:
				get_parent().change_state("ChainDestruction")
			4:
				get_parent().change_state("DischargeDouble")
