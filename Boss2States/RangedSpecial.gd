extends State

var arrow = preload("res://Characters/arrow.tscn")
var LineAOE = preload("res://Boss2States/line_aoe.tscn")
@onready var line_aoe_audio: AudioStreamPlayer2D = $"../../LineAOEAudio"

@onready var spawn_radius: float = 120
@onready var num_attacks = 7
var can_transition = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("ranged_special")
	animation_player.play("idle_right")
	await owner.attack_meter_animation.animation_finished
	animation_player.play("jump_away")
	await get_tree().create_timer(2).timeout #one second add
	owner.boss_room_animation.play("ranged_lines")
	await get_tree().create_timer(8).timeout
	await get_tree().create_timer(2).timeout
	owner.boss_room.spawn_special_part_2(true, 450.0, 22.5)
	await get_tree().create_timer(15).timeout #1 second added
	owner.ranged_special_finish()
	##animation_player.play("jump_away")
	##await animation_player.animation_finished
	#
	#owner.boss_room_animation.play("ranged_lines")
	## seconds 1, 3, 5, 7
	#await get_tree().create_timer(0.5).timeout #0.5
	#animation_player.play("special_stomp") #0.5s
	#await animation_player.animation_finished
	#animation_player.play("idle_left")
	#await get_tree().create_timer(0.9167).timeout
	#animation_player.play("special_stomp") #2.5s
	#await animation_player.animation_finished
	#animation_player.play("idle_left")
	#await get_tree().create_timer(0.9167).timeout
	#animation_player.play("special_stomp") #4.5s
	#await animation_player.animation_finished
	#animation_player.play("idle_left")
	#await get_tree().create_timer(0.9167).timeout
	#animation_player.play("special_stomp") #6.5s
	#await animation_player.animation_finished
	#animation_player.play("idle_left")
	#await owner.boss_room_animation.animation_finished
	#
	##animation_player.play("jump_land")
	##await animation_player.animation_finished
	#
	#owner.attack_meter_animation.play("ranged_special_2")
	#animation_player.play("idle_left")
	#await owner.attack_meter_animation.animation_finished
	#
	#animation_player.play("jump_away")
	#await animation_player.animation_finished
	#
	#owner.boss_room.spawn_special_part_2(0, 180, 15, 0.5)
	## await
	#await get_tree().create_timer(3).timeout
	#spawn_line_attacks(owner.to_local(player.global_position))
	#await get_tree().create_timer(1.5004).timeout
	##line_aoe_audio.play()
	#await get_tree().create_timer(0.9996).timeout
	## await
	#spawn_line_attacks(owner.to_local(player.global_position))
	#await get_tree().create_timer(1.5004).timeout
	##line_aoe_audio.play()
	#await get_tree().create_timer(0.9996).timeout
	##await
	#spawn_line_attacks(owner.to_local(player.global_position))
	#await get_tree().create_timer(1.5004).timeout
	##line_aoe_audio.play()
	#await get_tree().create_timer(0.9996).timeout
	#print("finished ranged_lines animation")
	#owner.position = owner.center_of_screen + Vector2(50, 0)
	#animation_player.play("jump_land")
	#owner.ranged_special_finish()
	##await get_tree().create_timer(2).timeout
	#await animation_player.animation_finished
	#
	#animation_player.play("idle_left")
	#await get_tree().create_timer(1.5833).timeout
	
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
	await get_tree().create_timer(0.9996).timeout
	line_aoe_audio.play()

func transition():
	if can_transition:
		can_transition = false
