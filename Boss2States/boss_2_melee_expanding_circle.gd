extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
#var MeleeSpecial2 = preload("res://Other/melee_special_part_2.tscn")
var center_of_arena = get_viewport_rect().size / 2 
var vertex_radius = 100

var track_position: Vector2
var track_opposite: Vector2

var vertex_angles = [
		deg_to_rad(-60),
		deg_to_rad(0),
		deg_to_rad(60),
		deg_to_rad(120),
		deg_to_rad(180),
		deg_to_rad(240)
	]
var last_random_index = -1

var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("expanding_circle")
	animation_player.play("idle_right")
	await owner.attack_meter_animation.animation_finished
	
	animation_player.play("jump_away")
	await get_tree().create_timer(1).timeout # 4 seconds
	#owner.position = owner.center_of_screen
	owner.boss_room_animation.play("expanding_circles")
	await owner.boss_room_animation.animation_finished # 4 seconds
	
	owner.boss_room_animation.play("expanding_circles")
	await owner.boss_room_animation.animation_finished # 4 seconds
	
	pick_random_vertex()
	owner.boss_2_main.melee_slam_special(track_position)
	owner.boss_2_main.melee_slam_special(track_opposite)
	print(track_position)
	print(track_opposite)
	await get_tree().create_timer(7).timeout #removed one second
	owner.finish_wicked_heart()
	# Jump to opposite side
	
	
	
	
	#owner.position = center_of_arena
	#animation_player.play("jump_land")
	#await animation_player.animation_finished
	
	#animation_player.play("idle_right")
	#
	#owner.attack_meter_animation.play("expanding_circle")
	#animation_player.play("idle_right")
	#await owner.attack_meter_animation.animation_finished
	#
	#animation_player.play("jump_away")
	#await animation_player.animation_finished
	#
	##owner.position = center_of_arena
	#
	#owner.boss_room_animation.play("expanding_circles")
	#await get_tree().create_timer(1.8326).timeout
	#
	#animation_player.play("special_pound")
	#await owner.boss_room_animation.animation_finished
	#
	#animation_player.play("special_jump")
	#await animation_player.animation_finished
	#
	#owner.boss_room_animation.play("expanding_circles")
	#await get_tree().create_timer(1.8326).timeout
	#
	#animation_player.play("special_pound")
	#await owner.boss_room_animation.animation_finished
	#animation_player.play("idle_right")
	#
	#owner.attack_meter_animation.play("expanding_circle_2")
	#animation_player.play("idle_right")
	#await owner.attack_meter_animation.animation_finished
	#
	#animation_player.play("jump_away")
	#await animation_player.animation_finished
	#
	#move_boss_to_random_vertex(owner)
	#
	#
	#animation_player.play("special_pound")
	#await animation_player.animation_finished
	#animation_player.play("special_jump")
	#await animation_player.animation_finished
	##move_boss_to_random_vertex(owner, true)
	#
	#await get_tree().create_timer(1.8326).timeout
	#
	#animation_player.play("special_pound")
	#await get_tree().create_timer(2.25).timeout
	#animation_player.play("special_jump")
	#await get_tree().create_timer(1).timeout
	#owner.position = owner.center_of_screen + Vector2(-50, 0)
	#
	#animation_player.play("jump_land")
	#owner.melee_special_finish()
	#
	##await get_tree().create_timer(2).timeout
	#await animation_player.animation_finished
	#
	#animation_player.play("idle_right")
	#await get_tree().create_timer(1.5833).timeout
	
	can_transition = true

#func melee_slam_special(position: Vector2):
	#var melee_slam = MeleeSpecial2.instantiate()
	#add_child(melee_slam)

func pick_random_vertex():	
	#var random_index = randi() % vertex_angles.size()
	#var chosen_angle = vertex_angles[random_index]
	#
	#var opposite_index = (random_index + int(vertex_angles.size() / 2)) % vertex_angles.size()
	#var opposite_angle = vertex_angles[opposite_index]
		
	var target_position = center_of_arena + Vector2(
		cos(deg_to_rad(-90)),
		sin(deg_to_rad(-90))
	) * vertex_radius
	
	var opposite_position = center_of_arena + Vector2(
		cos(deg_to_rad(90)),
		sin(deg_to_rad(90))
	) * vertex_radius
	
	track_opposite = opposite_position
	track_position = target_position
	#owner.position = target_position

func transition():
	if can_transition:
		can_transition = false
		#get_parent().change_state("JumpPosition")
