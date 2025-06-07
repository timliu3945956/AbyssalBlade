extends State

var can_transition: bool = false
var dash_position: Vector2

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	randomize()
	owner.attack_meter_animation.play("bait_cleave")
	var tween = get_tree().create_tween()
	tween.tween_property(owner.sword_sprite, "self_modulate:a", 1.0, 0.5)
	var tween_sword = get_tree().create_tween()
	tween_sword.tween_property(owner.static_sword, "self_modulate:a", 1.0, 0.5)
	owner.sword_follow_timer.start()
	#if owner.pick_direction == 1:
	owner.cleave_sword_anim.play("sword_telegraph")
	#else:
		#owner.cleave_sword_anim.play("sword_telegraph_counterclockwise")
	await owner.attack_meter_animation.animation_finished
	var dir: Vector2 = (player.global_position - owner.global_position).normalized()
	owner.cleave_sword_anim.play("sword_blink")
	owner.cleave_direction =  (player.global_position - owner.global_position).normalized()
	
	owner.attack_meter_animation.play("line_aoe")
	owner.boss_room.spawn_octahit()
	player.spawn_sword()
	await owner.attack_meter_animation.animation_finished
	var store_position = player.position
	dash_position = player.global_position
	await get_tree().create_timer(0.6666).timeout
	move_boss_to_player(store_position, owner)
	dash_toward_player()
	owner.dash.play()
	#if owner.pick_direction == 1:
	
	#else:
		#owner.cleave_direction = Vector2.RIGHT.rotated(owner.sword_marker_main.rotation + deg_to_rad(-90))
	print("direction of cleave Vector2D: ", owner.cleave_direction)
	await get_tree().create_timer(0.29).timeout
	owner.octahit_audio.play()
	owner.camera_shake()
	await get_tree().create_timer(0.10).timeout
	attack_towards_player(owner.cleave_direction)
	await get_tree().create_timer(0.45).timeout
	owner.blade_of_ruin_audio.play()
	await get_tree().create_timer(0.6).timeout
	
	owner.spawn_cleave()
	owner.cleave_sword_anim.play("RESET")
	owner.sword_sprite.self_modulate.a = 0
	owner.static_sword.self_modulate.a = 0
	owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	await get_tree().create_timer(0.7).timeout
	
	owner.attack_meter_animation.play("triple_cleave")
	await owner.attack_meter_animation.animation_finished
	
	owner.spawn_triple_cleave()
	await get_tree().create_timer(0.5).timeout
	
	owner.spawn_triple_cleave()
	await get_tree().create_timer(0.5).timeout
	owner.state_machine.travel("downattack_stand")
	
	owner.spawn_triple_cleave()
	await get_tree().create_timer(0.5).timeout
	owner.state_machine.travel("downattack_stand")
	
	await get_tree().create_timer(0.5).timeout
	owner.state_machine.travel("downattack_stand")
	await get_tree().create_timer(1).timeout
	owner.attack_sequence += 1
	can_transition = true
	
func move_boss_to_player(player_position: Vector2, boss: Node2D):
	var move_boss = get_tree().create_tween()
	move_boss.tween_property(boss, "position", player_position, 0.3332) #0.4 seconds before change
	
func dash_toward_player() -> void:
	var dir: Vector2 = (dash_position - owner.global_position).normalized()
	owner.animation_tree.set("parameters/Dash/blend_position", dir)
	owner.state_machine.travel("Dash")

func attack_towards_player(direction: Vector2) -> void:
	owner.animation_tree.set("parameters/Cleave/blend_position", direction)
	owner.state_machine.travel("Cleave")

func transition():
	if can_transition:
		can_transition = false
		match owner.attack_sequence:
			1:
				get_parent().change_state("GoldCloneSpawn")
			2:
				get_parent().change_state("WalkCenter")
			3:
				get_parent().change_state("GoldCloneSpawn")
			4:
				get_parent().change_state("WalkCenter")
			5:
				get_parent().change_state("WalkCenter")
		#get_parent().change_state("WalkCenter")
		#match owner.attack_sequence:
			#1:
				#get_parent().change_state("WalkCenter")
			#2:
				#get_parent().change_state("WalkCenter")
			#3
