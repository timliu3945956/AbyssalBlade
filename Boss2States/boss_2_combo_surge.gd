extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"

var center_of_screen = get_viewport_rect().size / 2 
var LineAOE = preload("res://Boss2States/line_aoe.tscn")

var center_of_arena = get_viewport_rect().size / 2 
var vertex_radius = 179.0

@onready var spawn_radius: float = 100.0
@onready var num_attacks = 7
const HIT_DURATION = 1.1

var can_transition: bool = false

var triangle_centers = [
	Vector2(50, -86.6),
	Vector2(-50, -86.6),
	Vector2(-100, 0),
	Vector2(-50, 86.6),
	Vector2(50, 86.6),
	Vector2(100, 0)
]

signal attack_done

func enter():
	super.enter()
	owner.set_physics_process(true)
	if owner.direction.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	owner.attack_meter_animation.play("harrowing_surge")
	await owner.attack_meter_animation.animation_finished
	
	# Line AOEs 2x
	animation_player.play("disappear")
	owner.smoke.play("smoke")
	await TimeWait.wait_sec(0.6)#await get_tree().create_timer(0.6).timeout
	
	owner.position = center_of_screen
	animation_player.play("appear")
	owner.smoke.play("smoke")
	
	spawn_line_attacks(player.position)
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	spawn_line_attacks(player.position)
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	#spawn_line_attacks(player.position)
	#await get_tree().create_timer(2).timeout
	#spawn_line_attacks(player.position)
	#await get_tree().create_timer(2).timeout
	
	#Add Boss Slam here
	
	# Chain Tiles
	start_triangle_mechanic()
	await TimeWait.wait_sec(5)#await get_tree().create_timer(5).timeout
	
	# Line AOEs 2x
	animation_player.play("disappear")
	owner.smoke.play("smoke")
	await TimeWait.wait_sec(0.6)#await get_tree().create_timer(0.6).timeout
	
	owner.position = center_of_screen
	animation_player.play("appear")
	owner.smoke.play("smoke")
	
	spawn_line_attacks(player.position)
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	spawn_line_attacks(player.position)
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	
	start_triangle_mechanic()
	await TimeWait.wait_sec(5)#await get_tree().create_timer(5).timeout
	
	if owner.boss_death == false:
		can_transition = true
	
# Line AOEs
func spawn_line_attacks(player_position: Vector2):
	for i in range(num_attacks):
		var attack_instance = LineAOE.instantiate()
		var position_angle = randf() * TAU
		#var angle = randf() * TAU
		var distance = randf() * spawn_radius
		 
		var offset = Vector2(distance, 0).rotated(position_angle)
		
		var rotation_angle = randf() * TAU
		attack_instance.position = owner.player.position + offset
		attack_instance.rotation = rotation_angle
		
		add_child(attack_instance)
		
# Chain Tiles
func start_triangle_mechanic():
	var start_index = randi_range(0, 5)
	var first = [start_index]
	owner.position = center_of_screen + triangle_centers[start_index]

	var second = [warp_index(start_index - 1), warp_index(start_index + 1)]
	var third = [warp_index(start_index - 2), warp_index(start_index + 2)]
	var fourth = [warp_index(start_index + 3)]
	
	
	activate_triangles(first)
	await get_tree().create_timer(HIT_DURATION).timeout
	activate_triangles(second)
	await get_tree().create_timer(HIT_DURATION).timeout
	activate_triangles(third)
	await get_tree().create_timer(HIT_DURATION).timeout
	activate_triangles(fourth)
	await get_tree().create_timer(HIT_DURATION).timeout

func warp_index(index: int) -> int:
	if index < 0:
		index += 6
	elif index > 5:
		index -= 6
	return index
	
func activate_triangles(triangle_indices: Array) -> void:
	#for index in triangle_indices:
	activate_triangle(triangle_indices[0], true)
	if triangle_indices.size() > 1:
		activate_triangle(triangle_indices[1], false)
	
func activate_triangle(triangle_index: int, one_player: bool) -> void:
	var anim_name = "triangle_%d" % (triangle_index)
	if !one_player:
		owner.triangle_animation_2.play(anim_name)
	else:
		owner.triangle_animation.play(anim_name)
	
	#if not one_player:
		#owner.triangle_animation_2.play(anim_name)
		
	await get_tree().create_timer(HIT_DURATION).timeout

#func move_boss_to_random_vertex(boss: Node2D):
	#var vertex_angles = [
		#deg_to_rad(-90),
		#deg_to_rad(-30),
		#deg_to_rad(30),
		#deg_to_rad(90),
		#deg_to_rad(150),
		#deg_to_rad(210)
	#]
	#
	#var random_index = randi() % vertex_angles.size()
	#var chosen_angle = vertex_angles[random_index]
	#print(chosen_angle)
	#
	#var target_position = center_of_arena + Vector2(
		#cos(chosen_angle),
		#sin(chosen_angle)
	#) * vertex_radius
	#
	#owner.position = target_position

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Beam")
 
