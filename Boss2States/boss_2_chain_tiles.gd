extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var chain_tiles_audio: AudioStreamPlayer2D = $"../../ChainTilesAudio"

var center_of_screen = get_viewport_rect().size / 2 

var can_transition: bool = false
const HIT_DURATION = 0.6
var first_triangle_check: int

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
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	
	owner.attack_meter_animation.play("chain_impact")
	await owner.attack_meter_animation.animation_finished
	
	animation_player.play("jump")
	await animation_player.animation_finished
	owner.boss_attack_animation.play("chain_impact")
	await TimeWait.wait_sec(2.8333)#await get_tree().create_timer(2.8333).timeout
	owner.position = owner.center_of_screen + Vector2(100, 0)
	if owner.center_of_screen.x - owner.position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	animation_player.play("slamdown")
	await animation_player.animation_finished
	
	if owner.boss_death == false:
		can_transition = true
	
func start_triangle_mechanic():
	var start_index = randi_range(0, 5)
	var first = [start_index]
	first_triangle_check = start_index
	owner.position = center_of_screen + triangle_centers[start_index]
	
	var second = [warp_index(start_index - 1), warp_index(start_index + 1)]
	var third = [warp_index(start_index - 2), warp_index(start_index + 2)]
	var fourth = [warp_index(start_index + 3)]
	
	activate_triangles(first)
	await get_tree().create_timer(HIT_DURATION + 0.5).timeout
	owner.camera_shake()
	owner.chain_tiles_audio.play()
	activate_triangles(second)
	await get_tree().create_timer(HIT_DURATION).timeout
	owner.camera_shake()
	chain_tiles_audio.play()
	activate_triangles(third)
	await get_tree().create_timer(HIT_DURATION).timeout
	owner.camera_shake()
	chain_tiles_audio.play()
	activate_triangles(fourth)
	await get_tree().create_timer(HIT_DURATION).timeout
	owner.camera_shake()
	chain_tiles_audio.play()

func warp_index(index: int) -> int:
	if index < 0:
		index += 6
	elif index > 5:
		index -= 6
	return index
	
func activate_triangles(triangle_indices: Array) -> void:
	#for index in triangle_indices:
	if first_triangle_check == triangle_indices[0]:
		activate_triangle(triangle_indices[0], true, true)
		first_triangle_check = -1
	else:
		activate_triangle(triangle_indices[0], true)
		if triangle_indices.size() > 1:
			activate_triangle(triangle_indices[1], false)
	
func activate_triangle(triangle_index: int, one_player: bool, first_triangle_pass: int = false) -> void:
	var anim_name = "triangle_%d" % (triangle_index)
	if first_triangle_pass:
		owner.triangle_animation_long.play(anim_name)
		await get_tree().create_timer(HIT_DURATION + 0.5).timeout
	else:
		if !one_player:
			owner.triangle_animation_2.play(anim_name)
		else:
			owner.triangle_animation.play(anim_name)
		await get_tree().create_timer(HIT_DURATION).timeout
	
	#if not one_player:
		#owner.triangle_animation_2.play(anim_name)
		
	
	
	

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Beam")
 
