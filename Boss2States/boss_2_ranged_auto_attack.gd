extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
#var arrow = preload("res://Characters/arrow.tscn")
var LaserBeam = preload("res://Other/beam_dodge_mini.tscn")
@onready var auto_attack_audio: AudioStreamPlayer2D = $"../../AutoAttackAudio"

var center_of_arena = get_viewport_rect().size / 2 
var radius = 110
var attack_counter = 0
var can_transition: bool = false

var current_vertex_index: int = 0

func enter():
	super.enter()
	owner.set_physics_process(true)
	
	#move_boss()
	#if center_of_arena.x - position.x > 0:
		#animation_player.play("idle_right")
	#else:
		#animation_player.play("idle_left")
		
	#await get_tree().create_timer(0.1666).timeout
	
	animation_player.play("charge")
	if center_of_arena.x - owner.position.x > 0:
		owner.sprite.flip_h = false
		owner.sprite_shadow.flip_h = false
	else:
		owner.sprite.flip_h = true
		owner.sprite_shadow.flip_h = true
	await get_tree().create_timer(2).timeout
	
	
	#animation_player.play("into_charge")
	#await animation_player.animation_finished
	
	
	owner.beam_rotation.rotation = owner.beam_rotation.global_position.angle_to_point(player.global_position)
	owner.beam_animation_player.play("beam_telegraph")
	var beam_rotation = player.global_position - global_position #was using global position
	await get_tree().create_timer(0.7501).timeout
	if center_of_arena.x - owner.position.x > 0:
		owner.sprite.flip_h = false
		owner.sprite_shadow.flip_h = false
	else:
		owner.sprite.flip_h = true
		owner.sprite_shadow.flip_h = true
		
	animation_player.play("beam")
	await get_tree().create_timer(0.0998).timeout
	auto_attack_audio.play()
	await owner.beam_animation_player.animation_finished
	
	#await get_tree().create_timer(0.1501).timeout
	#auto_attack_audio.play()
	#await get_tree().create_timer(0.2499).timeout
	
	
	beam(beam_rotation)
	await get_tree().create_timer(1).timeout
	
	owner.auto_attack_count += 1
	can_transition = true
	
func beam(rotation: Vector2):
	var beam = LaserBeam.instantiate()
	#beam.position = Vector2(0, -6)
	beam.rotation = (rotation).angle()
	#beam.position.angle_to_point(player.position)
	add_child(beam)
	print("beam being instantiated")
	
func move_boss():
	# Generate the 6 positions around arena
	var positions = get_vertex_positions()
	
	move_boss_to_furthest_adjacent_vertex(owner, owner.player, positions)

func get_vertex_positions() -> Array:
	var vertex_angles = [
		deg_to_rad(-30),
		deg_to_rad(-90),
		deg_to_rad(-150),
		deg_to_rad(150),
		deg_to_rad(90),
		deg_to_rad(30),
	]
	
	var positions: Array = []
	for angle in vertex_angles:
		var pos = owner.center_of_screen + Vector2(cos(angle), sin(angle)) * radius
		positions.append(pos)
	print(positions)
	return positions
	
	
func move_boss_to_furthest_adjacent_vertex(boss: Node2D, player: Node2D, vertex_positions: Array):
	var boss_index = current_vertex_index
	
	# 2) Determine the two adjacent vertices
	var next_index = (boss_index + 1) % vertex_positions.size()
	var prev_index = (boss_index - 1 + vertex_positions.size()) % vertex_positions.size()
	
	# 3) Compare distances of these two vertices from the player
	print("center of screen: ", owner.center_of_screen)
	print(vertex_positions[next_index])
	print(owner.player.global_position)
	var dist_next = (vertex_positions[next_index]+Vector2(240, 135) - owner.player.global_position).length()
	var dist_prev = (vertex_positions[prev_index]+Vector2(240, 135) - owner.player.global_position).length()
	print("current vertex: ", current_vertex_index)
	print("dist_next: ", dist_next)
	print("dist_prev: ", dist_prev)
	print("next_index: ", next_index)
	print("prev_index: ", prev_index)
	
	var chosen_index = 0
	if dist_next > dist_prev:
		chosen_index = next_index
	else:
		chosen_index = prev_index
	
	
	#current_vertex_index = chosen_index
	
	var tween = get_tree().create_tween()
	tween.tween_property(boss, "position", vertex_positions[chosen_index], 1.0)
	current_vertex_index = chosen_index
	if vertex_positions[chosen_index].x - owner.position.x > 0:
		animation_player.play("walk_right")
	else:
		animation_player.play("walk_left")
	return tween
	
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
		if owner.auto_attack_count == 3:
			get_parent().change_state("Foretold")
		elif owner.auto_attack_count == 9:
			get_parent().change_state("Foretold")
		elif owner.auto_attack_count == 12:
			get_parent().change_state("Foretold")
		elif owner.auto_attack_count == 15:
			get_parent().change_state("WickedMind")
		else:
			enter()
