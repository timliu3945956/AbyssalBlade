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
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout # 4 seconds
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
	await TimeWait.wait_sec(7)#await get_tree().create_timer(7).timeout #removed one second
	owner.finish_wicked_heart()
	# Jump to opposite side
	can_transition = true


func pick_random_vertex():
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
