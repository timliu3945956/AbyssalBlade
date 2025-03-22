extends State

var can_transition: bool = false
var LaserBeam = preload("res://Characters/beam.tscn")
var LightningDodge = preload("res://Other/LightningDodge.tscn")

var last_removed_angle_1 := -1.0
var last_removed_angle_2 := -1.0

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	#animation_player.play("disappear")
	#owner.smoke.play("smoke")
	#await get_tree().create_timer(0.6).timeout
	animation_player.play("idle_left")
	await get_tree().create_timer(0.75).timeout
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
	#await get_tree().create_timer(0.25).timeout
	#animation_player.play("dash_stop")
	#await get_tree().create_timer(0.25).timeout
	
	#animation_player.play("appear")
	#owner.smoke.play("smoke")
	owner.attack_meter_animation.play("discharge_double")
	animation_player.play("idle_right")
	#animation_player.play("cleave_chargeup")
	#await animation_player.animation_finished #0.4167
	#animation_player.play("cleave_charge")
	#await get_tree().create_timer(1.5833).timeout
	await get_tree().create_timer(2.25).timeout
	animation_player.play("buff")
	owner.boss_attack_animation.play("sword_telegraph_double")
	await get_tree().create_timer(0.5834).timeout
	owner.sword_animation.play("sword_drop_double")
	await get_tree().create_timer(0.1666).timeout
	owner.camera_shake()
	#await owner.attack_meter_animation.animation_finished
	
	await get_tree().create_timer(0.5).timeout
	#animation_player.play("cleave_reverse")
	
	#owner.boss_attack_animation.play("sword_drop")
	#await owner.boss_attack_animation.animation_finished
	
	animation_player.play("idle_right")
	await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_repeat") # 1.5 seconds
	#await get_tree().create_timer(1).timeout
	lightning() # 2 seconds
	
	await get_tree().create_timer(1.52).timeout
	animation_player.play("discharge_last") # 1.5 seconds
	await animation_player.animation_finished
	owner.sword_animation.play("sword_end_double")
	await owner.sword_animation.animation_finished
	#animation_player.play("idle_right")
	#await get_tree().create_timer(0.5).timeout
	owner.discharge_count += 1
	if owner.boss_death == false:
		can_transition = true
	
func beam(rotation: Vector2):
	var beam = LaserBeam.instantiate()
	beam.position = Vector2(0, -6)
	beam.rotation = (rotation).angle()
	#beam.position.angle_to_point(player.position)
	add_child(beam)
	print("beam being instantiated")
	
func lightning():
	var aoe_count = 10
	var min_spacing = 10.0
	var middle_min = 70.0
	var middle_max = 110.0
	#
	#var guaranteed_middle_count = 4
	var forced_middle_angles = [70.0, 80.0, 90.0, 100.0, 110.0] #removed 70 and 110
	
	var index1 = randi() % forced_middle_angles.size()
	var angle1 = forced_middle_angles[index1]
	
	while angle1 == last_removed_angle_1 or angle1 == last_removed_angle_2:
		index1 = randi() % forced_middle_angles.size()
		angle1 = forced_middle_angles[index1]
	index1 = forced_middle_angles.find(angle1)
	print("it can get here before crashing")
	var adjacent_indices = []
	if index1 > 0:
		adjacent_indices.append(index1 - 1)
	if index1 < forced_middle_angles.size() - 1:
		adjacent_indices.append(index1 + 1)
		
	var index2 = adjacent_indices[randi() % adjacent_indices.size()]
	var angle2 = forced_middle_angles[index2]
	
	#while angle2 == last_removed_angle_1 or angle2 == last_removed_angle_2:
		#index2 = adjacent_indices[randi() % adjacent_indices.size()]
		#angle2 = forced_middle_angles[index2]
		
	if index2 > index1:
		forced_middle_angles.remove_at(index2)
		forced_middle_angles.remove_at(index1)
	else:
		forced_middle_angles.remove_at(index1)
		forced_middle_angles.remove_at(index2)
	
	last_removed_angle_1 = angle1
	last_removed_angle_2 = angle2
	
	var used_angles = []
	
	for angle in forced_middle_angles:
		used_angles.append(angle)
	print("it can get here before crashing")
	var remaining_count = aoe_count - forced_middle_angles.size()
	if remaining_count > 0:
		for angle in range(remaining_count):
			while true:
				var candidate = randf_range(0.0, 180.0)
				
				if candidate >= middle_min and candidate <= middle_max:
					continue
					
				var valid = true
				for used in used_angles:
					if abs(candidate - used) < min_spacing:
						valid = false
						break
						
				if valid:
					used_angles.append(candidate)
					break
					
	for angle in used_angles:
		var aoe = LightningDodge.instantiate()
		aoe.position = Vector2(0, -110)
		add_child(aoe)
		
		aoe.rotation = deg_to_rad(angle)
#func lightning():
	#var aoe_count = 10
	#var min_spacing = 10.0
	#var middle_min = 70.0
	#var middle_max = 110.0
	##
	##var guaranteed_middle_count = 4
	#var forced_middle_angles = [70.0, 80.0, 90.0, 100.0, 110.0] #removed 70 and 110
	#
	#var index1 = randi() % forced_middle_angles.size()
	#var angle1 = forced_middle_angles[index1]
	#
	#while angle1 == last_removed_angle_1 or angle1 == last_removed_angle_2:
		#index1 = randi() % forced_middle_angles.size()
		#angle1 = forced_middle_angles[index1]
	#index1 = forced_middle_angles.find(angle1)
	#print("it can get here before crashing")
	#var adjacent_indices = []
	#if index1 > 0:
		#adjacent_indices.append(index1 - 1)
	#if index1 < forced_middle_angles.size() - 1:
		#adjacent_indices.append(index1 + 1)
		#
	#var index2 = adjacent_indices[randi() % adjacent_indices.size()]
	#var angle2 = forced_middle_angles[index2]
	#
	##while angle2 == last_removed_angle_1 or angle2 == last_removed_angle_2:
		##index2 = adjacent_indices[randi() % adjacent_indices.size()]
		##angle2 = forced_middle_angles[index2]
		#
	#if index2 > index1:
		#forced_middle_angles.remove_at(index2)
		#forced_middle_angles.remove_at(index1)
	#else:
		#forced_middle_angles.remove_at(index1)
		#forced_middle_angles.remove_at(index2)
	#
	#last_removed_angle_1 = angle1
	#last_removed_angle_2 = angle2
	#
	#var used_angles = []
	#
	#for angle in forced_middle_angles:
		#used_angles.append(angle)
	#print("it can get here before crashing")
	#var remaining_count = aoe_count - forced_middle_angles.size()
	#if remaining_count > 0:
		#for angle in range(remaining_count):
			#while true:
				#var candidate = randf_range(0.0, 180.0)
				#
				#if candidate >= middle_min and candidate <= middle_max:
					#continue
					#
				#var valid = true
				#for used in used_angles:
					#if abs(candidate - used) < min_spacing:
						#valid = false
						#break
						#
				#if valid:
					#used_angles.append(candidate)
					#break
					#
	#for angle in used_angles:
		#var aoe = LightningDodge.instantiate()
		#aoe.position = Vector2(0, -110)
		#aoe.rotation = deg_to_rad(angle)
		#add_child(aoe)
	#
	#for angle in used_angles:
		#var mirrored_angle = 360.0 - angle
		#var aoe_bottom = LightningDodge.instantiate()
		#aoe_bottom.position = Vector2(0, 110)
		#aoe_bottom.rotation = deg_to_rad(mirrored_angle)
		#add_child(aoe_bottom)
		#
	
	#
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Enrage")
