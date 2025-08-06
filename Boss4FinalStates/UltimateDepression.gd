extends State

var oppressive_pick: int = randi_range(1, 2)
var can_transition: bool = false
var RedOrb = preload("res://Other/DevourRed.tscn")
var DepressionOrb = preload("res://Other/DepressionOrb.tscn")
var spawn_count : int = 0

func enter():
	super.enter()
	owner.attack_meter_animation.play("ultimate_depression")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#animation_player.play("raise_hand")
	owner.room_change_player.play("depression")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_animation.play("flash_screen")
	owner.boss_room.devour_circle_animation.play("circle_appear")
	#animation_player.play("hand_down")
	owner.boss_room.change_stage_texture("depression")
	await owner.enrage_animation.animation_finished
	owner.boss_room.ground_aura()
	owner.boss_room.devour_circle_animation.play("circle_pulse")
	
	var tween = get_tree().create_tween()
	tween.tween_property(owner.devour_meter, "modulate:a", 1, 0.5)
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	#orb_spawn()
	#await get_tree().create_timer(2).timeout
	pillar_spawn(owner.center_of_screen + Vector2(-59, -59))
	pillar_spawn_2(owner.center_of_screen + Vector2(59, 59))
	pillar_spawn_3(owner.center_of_screen + Vector2(59, -59))
	pillar_spawn_4(owner.center_of_screen + Vector2(-59, 59))
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	await spawn_orbs()
	
	await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout
	owner.devour_meter.visible = false

	can_transition = true
	
func spawn_orbs():
	var wave_data = [
		{"orb_count": 4, "repeat": 2, "order": [7, 1, 3, 5, 8, 2, 4, 6]}, # 12 seconds
		{"orb_count": 4, "repeat": 2, "order": [7, 1, 3, 5, 8, 2, 4, 6]}, # 6 seconds
		{"orb_count": 4, "repeat": 2, "order": [7, 1, 3, 5, 8, 2, 4, 6]}, # 3 second
		{"orb_count": 4, "repeat": 2, "order": [7, 1, 3, 5, 8, 2, 4, 6]}  # 1.5 seconds
	]
	
	for wave_info in wave_data:
		#owner.orb_buff_vfx()
		
		orb_spawn()
		await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
		var orb_count = wave_info["orb_count"]
		var repeat_times = wave_info["repeat"]
		var spawn_order = wave_info["order"]
		
		var spawn_index = 0
		
		for r in range(repeat_times):
			for i in range(orb_count):
				var boss_num = spawn_order[spawn_index]
				
				var orb = RedOrb.instantiate()
				orb.position = get_boss_position(boss_num - 1)
				orb.boss = owner
				get_parent().get_parent().get_parent().devour_orb_spawn.add_child(orb)
				
				spawn_index = (spawn_index + 1) % spawn_order.size()
				print(spawn_index)
				
			print("spawned", orb_count, "orbs in repetition #", r)
			await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
			
		await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout #4
		#spawn_count += 1
		#if spawn_count < 4:
			#orb_spawn()
		
func get_boss_position(index):
	var offset_distance = 140
	var angle = (index) * (TAU / 8)
	return owner.center_of_screen + Vector2(cos(angle), sin(angle)) * offset_distance
	
func orb_spawn():
	owner.orb = DepressionOrb.instantiate()
	owner.orb.position = owner.center_of_screen
	owner.orb.player = owner.player
	get_parent().get_parent().get_parent().add_child(owner.orb)
	
func pillar_spawn(pillar_position: Vector2):
	owner.pillar = owner.DestructivePillar.instantiate()
	owner.pillar.position = pillar_position
	owner.pillar.player = owner.player
	owner.pillar.timer_set = 32.0
	owner.pillar.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar)
	
func pillar_spawn_2(pillar_position: Vector2):
	owner.pillar_2 = owner.DestructivePillar2.instantiate()
	owner.pillar_2.position = pillar_position
	owner.pillar_2.player = owner.player
	owner.pillar_2.timer_set = 32.0
	owner.pillar_2.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_2)
	
func pillar_spawn_3(pillar_position: Vector2):
	owner.pillar_3 = owner.DestructivePillar3.instantiate()
	owner.pillar_3.position = pillar_position
	owner.pillar_3.player = owner.player
	owner.pillar_3.timer_set = 32.0
	owner.pillar_3.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_3)
	
func pillar_spawn_4(pillar_position: Vector2):
	owner.pillar_4 = owner.DestructivePillar4.instantiate()
	owner.pillar_4.position = pillar_position
	owner.pillar_4.player = owner.player
	owner.pillar_4.timer_set = 32.0
	owner.pillar_4.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_4)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("UltimateGrief") #AttackCombo
