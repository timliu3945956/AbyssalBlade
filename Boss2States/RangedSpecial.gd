extends State

var arrow = preload("res://Characters/arrow.tscn")
var LineAOE = preload("res://Boss2States/line_aoe.tscn")
@onready var line_aoe_audio: AudioStreamPlayer2D = $"../../LineAOEAudio"

@onready var spawn_radius: float = 120
@onready var num_attacks = 7
var direction = randi_range(1, 2)
var can_transition = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("ranged_special")
	animation_player.play("idle_right")
	await owner.attack_meter_animation.animation_finished
	animation_player.play("jump_away")
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout #one second add
	owner.boss_room_animation.play("ranged_lines")
	await TimeWait.wait_sec(8)#await get_tree().create_timer(8).timeout
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	if direction == 1:
		owner.boss_room.spawn_special_counterclockwise()
	else:
		owner.boss_room.spawn_special_clockwise()
	await TimeWait.wait_sec(5.25)#await get_tree().create_timer(5.25).timeout
	owner.boss_2_melee.find_child("FiniteStateMachine").change_state("Foretold")
	await TimeWait.wait_sec(8.75)#await get_tree().create_timer(8.75).timeout #1 second added
	owner.ranged_special_finish()
	
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
	await TimeWait.wait_sec(0.9996)#await get_tree().create_timer(0.9996).timeout
	line_aoe_audio.play()

func transition():
	if can_transition:
		can_transition = false
