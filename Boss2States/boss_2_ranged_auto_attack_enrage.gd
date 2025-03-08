extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
#var arrow = preload("res://Characters/arrow.tscn")
var LaserBeam = preload("res://Characters/beam.tscn")

var center_of_arena = get_viewport_rect().size / 2 
var radius = 110
var attack_counter = 0
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	
	move_boss()
	#move_boss_to_opposite(owner.player.global_position, owner)
	if owner.global_position.x - owner.player.global_position.x > 0:
		animation_player.play("walk_left")
	else:
		animation_player.play("walk_right")
	await get_tree().create_timer(1).timeout
	
	animation_player.play("into_charge")
	await animation_player.animation_finished
	
	animation_player.play("charge")
	await get_tree().create_timer(0.8334).timeout
	
	owner.beam_rotation.rotation = owner.beam_rotation.global_position.angle_to_point(player.global_position)
	owner.beam_animation_player.play("beam_telegraph")
	var beam_rotation = player.global_position - global_position
	await owner.beam_animation_player.animation_finished
	await get_tree().create_timer(0.4).timeout
	animation_player.play("beam")
	beam(beam_rotation)
	await get_tree().create_timer(0.6).timeout
	
	owner.beam_rotation.rotation = owner.beam_rotation.global_position.angle_to_point(player.global_position)
	owner.beam_animation_player.play("beam_telegraph")
	beam_rotation = player.global_position - global_position
	await owner.beam_animation_player.animation_finished
	await get_tree().create_timer(0.4).timeout
	animation_player.play("beam")
	beam(beam_rotation)
	await get_tree().create_timer(0.6).timeout
	
	owner.beam_rotation.rotation = owner.beam_rotation.global_position.angle_to_point(player.global_position)
	owner.beam_animation_player.play("beam_telegraph")
	beam_rotation = player.global_position - global_position
	await owner.beam_animation_player.animation_finished
	await get_tree().create_timer(0.4).timeout
	animation_player.play("beam")
	beam(beam_rotation)
	await get_tree().create_timer(0.6).timeout
	
	attack_counter += 1
	can_transition = true
	
func beam(rotation: Vector2):
	var beam = LaserBeam.instantiate()
	beam.position = Vector2(0, -6)
	beam.rotation = (rotation).angle()
	#beam.position.angle_to_point(player.position)
	add_child(beam)
	print("beam being instantiated")
	
func move_boss():
	
	# Generate the 6 positions around your arena
	var positions = get_vertex_positions()
	
	# Move the boss to the furthest adjacent vertex
	move_boss_to_furthest_adjacent_vertex(owner, player, positions)

func get_vertex_positions() -> Array:
	var vertex_angles = [
		deg_to_rad(-90),
		deg_to_rad(-30),
		deg_to_rad(30),
		deg_to_rad(90),
		deg_to_rad(150),
		deg_to_rad(210)
	]
	
	var positions: Array = []
	for angle in vertex_angles:
		var pos = center_of_arena + Vector2(cos(angle), sin(angle)) * radius
		positions.append(pos)
	return positions
	
func move_boss_to_furthest_adjacent_vertex(boss: Node2D, player: Node2D, vertex_positions: Array) -> void:
	# 1) Find which vertex the boss is currently at
	var boss_index = get_boss_vertex_index(boss.position, vertex_positions)
	
	# 2) Determine the two adjacent vertices (wrap with % for array bounds)
	var next_index = (boss_index + 1) % vertex_positions.size()
	var prev_index = (boss_index - 1 + vertex_positions.size()) % vertex_positions.size()
	
	# 3) Compare distances of these two vertices from the player
	var dist_next = vertex_positions[next_index].distance_to(player.global_position)
	var dist_prev = vertex_positions[prev_index].distance_to(player.global_position)
	
	# 4) Choose the further one (using if/else instead of ternary)
	var chosen_index = 0
	if dist_next > dist_prev:
		chosen_index = next_index
	else:
		chosen_index = prev_index
	
	# 5) Move (or tween) the boss
	#boss.position = vertex_positions[chosen_index]
	# Example tween if desired:
	var tween = get_tree().create_tween()
	tween.tween_property(boss, "position", vertex_positions[chosen_index], 1.0)
	
func get_boss_vertex_index(boss_pos: Vector2, vertex_positions: Array) -> int:
	# Finds the index of whichever vertex is closest to `boss_pos`
	var closest_index = 0
	var closest_dist = INF
	for i in range(vertex_positions.size()):
		var dist = boss_pos.distance_to(vertex_positions[i])
		if dist < closest_dist:
			closest_dist = dist
			closest_index = i
	return closest_index

func transition():
	if can_transition:
		can_transition = false
		if attack_counter == 9:
			get_parent().change_state("HandsOfDeath")
		elif attack_counter == 6:
			get_parent().change_state("HandsOfPain")
		elif attack_counter == 3:
			get_parent().change_state("HandsOfPain")
		else:
			enter()
		
