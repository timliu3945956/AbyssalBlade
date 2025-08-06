extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var line_aoe_audio: AudioStreamPlayer2D = $"../../LineAOEAudio"

var center_of_screen = get_viewport_rect().size / 2 
var LineAOE = preload("res://Boss2States/line_aoe.tscn")

@onready var spawn_radius: float = 120.0
@onready var num_attacks = 7

var can_transition: bool = false

signal attack_done

func enter():
	super.enter()
	owner.set_physics_process(true)
	if center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
		
	#var move_boss = get_tree().create_tween()
	#move_boss.tween_property(owner, "position", (center_of_screen), 0.8)
	#if (center_of_screen).x - owner.position.x > 0:
		#animation_player.play("walk_right")
	#else:
		#animation_player.play("walk_left")
	#await get_tree().create_timer(0.8).timeout
	owner.attack_meter_animation.play("electric_surge")
	await owner.attack_meter_animation.animation_finished
	
	
	
	spawn_line_attacks(owner.to_local(player.global_position))
	await TimeWait.wait_sec(0.4996)#await get_tree().create_timer(0.4996).timeout
	animation_player.play("discharge")
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	line_aoe_audio.play()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	
	#player.position
	spawn_line_attacks(owner.to_local(player.global_position))
	await TimeWait.wait_sec(0.4996)#await get_tree().create_timer(0.4996).timeout
	animation_player.play("discharge_repeat")
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	line_aoe_audio.play()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	
	spawn_line_attacks(owner.to_local(player.global_position))
	await TimeWait.wait_sec(0.4996)#await get_tree().create_timer(0.4996).timeout
	animation_player.play("discharge_last")
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	line_aoe_audio.play()
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	if center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	#await get_tree().create_timer(1).timeout
	
	owner.line_aoe_count += 1
	if owner.boss_death == false:
		can_transition = true
	
func spawn_line_attacks(player_position: Vector2):
	for i in range(num_attacks):
		var attack_instance = LineAOE.instantiate()
		var position_angle = randf() * TAU
		#var angle = randf() * TAU
		var distance = randf() * spawn_radius
		
		var offset = Vector2(distance, 0).rotated(position_angle)
		
		var rotation_angle = randf() * TAU
		attack_instance.position = player_position + offset
		attack_instance.rotation = rotation_angle
		
		add_child(attack_instance)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("ForwardCleave")
 
