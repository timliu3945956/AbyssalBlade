extends State

var RedOrb = preload("res://Other/DevourRed.tscn")

var can_transition: bool = false
var boss_room_center = Vector2.ZERO

var spawn_order = [7, 8, 1, 2, 3, 4, 5, 6]
var wave_size = [1, 2, 4, 8]

func enter():
	super.enter()
	set_process_input(true)
	animation_player.play("idle")
	owner.attack_meter_animation.play("devour")
	await owner.attack_meter_animation.animation_finished
	var tween = get_tree().create_tween()
	tween.tween_property(owner.devour_meter, "modulate:a", 1, 0.5)
	var dust_tween = get_tree().create_tween()
	dust_tween.tween_property(owner.dust_anim, "modulate:a", 0, 0.5)
	owner.orb_buff_vfx()
	await spawn_orbs()
	
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.devour_meter.visible = false
	dust_tween = get_tree().create_tween()
	dust_tween.tween_property(owner.dust_anim, "modulate:a", 1, 0.5)
	await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
	can_transition = true
	
func spawn_orbs():
	var wave_data = [
		{"orb_count": 1, "repeat": 8, "order": [7, 8, 1, 2, 3, 4, 5, 6]}, # 12 seconds
		{"orb_count": 2, "repeat": 4, "order": [7, 3, 8, 4, 1, 5, 2, 6]}, # 6 seconds
		{"orb_count": 4, "repeat": 2, "order": [7, 1, 3, 5, 8, 2, 4, 6]}, # 3 second
		{"orb_count": 8, "repeat": 1, "order": [1, 2, 3, 4, 5, 6, 7, 8]}  # 1.5 seconds
	]
	
	for wave_info in wave_data:
		owner.orb_buff_vfx()
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
				get_parent().get_parent().get_parent().add_child(orb)
				
				spawn_index = (spawn_index + 1) % spawn_order.size()
				
			print("spawned", orb_count, "orbs in repetition #", r)
			await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
			
		await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
		
func get_boss_position(index):
	var offset_distance = 140
	var angle = (index) * (TAU / 8)
	return owner.center_of_screen + Vector2(cos(angle), sin(angle)) * offset_distance

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("EngulfingCurse")
		#
		#can_transition = true
	
