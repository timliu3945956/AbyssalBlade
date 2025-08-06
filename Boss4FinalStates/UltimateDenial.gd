extends State

var ShadowCloneScene = preload("res://Characters/boss_4_shadow_player.tscn")
var BossCloneScene = preload("res://Characters/boss_clone.tscn")

@onready var shadow_state_timer: Timer = $"../../ShadowStateTimer"

var trigger_aoe_count: int = 0
var can_transition: bool = false

var expected_boss_indices: Array = []
var shadow_first_slice: int = 0
var shadow_walk_dir: int = 1

var boss_clones: Array = []
var current_boss_index: int = 0

var boss_room_center: Vector2 = Vector2.ZERO

func enter():
	super.enter()
	owner.attack_meter_animation.play("ultimate_denial")
	if player.global_position.x - owner.global_position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	#animation_player.play("raise_hand")
	owner.room_change_player.play("denial")
	await owner.attack_meter_animation.animation_finished
	owner.enrage_animation.play("flash_screen")
	#animation_player.play("hand_down")
	owner.boss_room.change_stage_texture("denial")
	await owner.enrage_animation.animation_finished
	#await get_tree().create_timer(1).timeout
	#animation_player.play("idle_right")
	#owner.boss_charge_animation.play("clone_spawn_2")
	#await owner.boss_charge_animation.animation_finished
	owner.circle_animation.play("circle_appear")
	await owner.circle_animation.animation_finished
	#animation_player.play("jump_away")
	spawn_shadow()
	for i in range(8):
		var meter_name := "vision_" + str(i + 1)
		owner.attack_meter_animation.play(meter_name)
		await owner.attack_meter_animation.animation_finished
		owner.boss_room_animation.play("invis_telegraph")
	#await owner.circle_animation.animation_finished
	#owner.attack_meter_animation.play("phantom_cleave")
	
	
	#await get_tree().create_timer(30).timeout
	
func spawn_shadow():
	var shadow_clone = ShadowCloneScene.instantiate()
	shadow_clone.position = owner.center_of_screen
	shadow_clone.boss_room_center = owner.center_of_screen
	shadow_clone.boss = owner
	add_child(shadow_clone)
	
	shadow_clone.connect("action_completed", self._on_shadow_done)
	
func _on_shadow_done(hit_slices: Array, start_slice: int, walk_dir: int, visit_order: Array) -> void:
	expected_boss_indices = hit_slices.duplicate()
	shadow_first_slice = start_slice
	shadow_walk_dir = walk_dir
	var invis_order = visit_order
	await get_tree().create_timer(1).timeout
	
	spawn_bosses()
	await play_animation(invis_order)

func play_animation(slice_indices: Array) -> void:
	#print("slice indices:", slice_indices)
	var ordered = []
	var idx = shadow_first_slice
	for i in range(8):
		if idx in slice_indices:
			ordered.append(idx)
		idx = (idx + shadow_walk_dir + 8) % 8
	var number := 1
	for index in ordered:
		var meter_name := "realization_" + str(number)
		owner.attack_meter_animation.play(meter_name)
		number += 1
		await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
		if player.global_position.x - owner.global_position.x > 0:
			owner.sprite.flip_h = false
		else:
			owner.sprite.flip_h = true
		animation_player.play("attack")
		await owner.attack_meter_animation.animation_finished
		#await owner.boss_charge_animation.animation_finished
		print("attack happens here")
		var anim_name := "safe_slice_" + str(index)
		owner.boss_room_animation.play(anim_name)
		owner.flash_room_animation.play("flash_arena")
		#print("ordered array:", ordered)
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	#animation_player.play("idle_right")
	
	owner.circle_animation.play("circle_disappear")
	
func spawn_bosses() -> void:
	shadow_state_timer.start()
	for index in range(8):
		var bc = BossCloneScene.instantiate()
		bc.position = get_boss_position(index)
		bc.boss_index = index
		bc.boss = owner
		get_parent().get_parent().get_parent().add_child(bc)
		bc.connect("boss_hit", self._on_boss_clone_hit)
		boss_clones.append(bc)
		
func get_boss_position(index: int) -> Vector2:
	var offset_distance := 110.0
	var angle := (index + 0.5) * (TAU / 8)
	return owner.center_of_screen + \
		Vector2(cos(angle), sin(angle)) * offset_distance
		
func _on_boss_clone_hit(boss_index: int) -> void:
	print(expected_boss_indices)
	if boss_index in expected_boss_indices:
		expected_boss_indices.erase(boss_index)
	else:
		var clone_hit: Node2D = null
		for c in boss_clones:
			if is_instance_valid(c) and c.boss_index == boss_index:
				clone_hit = c
				break
		if clone_hit:
			clone_hit.wrong_sac_explode()
			owner.boss_room_animation.play("arena_aoe_sac")
			trigger_aoe_count += 1

func cleanup_boss_clones() -> void:
	for c in boss_clones:
		if is_instance_valid(c):
			c.play_sac_explode()
	await TimeWait.wait_sec(1.5)#await get_tree().create_timer(1.5).timeout
	for c in boss_clones:
		if is_instance_valid(c):
			c.queue_free()
	boss_clones.clear()
	
func trigger_area_attack() -> void:
	#animation_player.play("buff_attack")
	await get_tree().create_timer(2).timeout
	cleanup_boss_clones()
	await get_tree().create_timer(0.0833).timeout
	owner.boss_room_animation.play("arena_aoe")
	await owner.boss_room_animation.animation_finished
	trigger_aoe_count += 1
	
func _on_shadow_state_timer_timeout() -> void:
	owner.attack_meter_animation.play("purge")
	await owner.attack_meter_animation.animation_finished
	owner.circle_animation.play("circle_disappear")
	if expected_boss_indices.is_empty():
		cleanup_boss_clones()
		await get_tree().create_timer(2).timeout
		can_transition = true
	elif trigger_aoe_count == 0:
		trigger_area_attack()
		
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("UltimateAnger") #AttackCombo
