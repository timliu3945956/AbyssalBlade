extends State

var ShadowCloneScene = preload("res://Characters/shadow_player_combo.tscn")
var BossCloneScene = preload("res://Characters/boss_clone.tscn")
@onready var shadow_state_timer: Timer = $"../../ShadowStateTimer2"
var trigger_aoe_count: int = 0

var can_transition: bool = false
var shadow_clones = []
var clones_completed = 0 # Keeping track of completed clones
var boss_clones = []
var expected_boss_indices = []
var current_boss_index = 0

var boss_room_center = Vector2.ZERO

func enter():
	super.enter()
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("clone_spawn_4")
	await owner.boss_charge_animation.animation_finished
	owner.circle_animation.play("circle_appear")
	animation_player.play("jump_away")
	
	#await animation_player.animation_finished
	await owner.circle_animation.animation_finished
	#owner.circle_animation.play("circle_flash")
	clones_completed = 0
	spawn_shadow()
	
func spawn_shadow():
	var all_indices = []
	for i in range(8):
		all_indices.append(i)
	var selected_indices = []
	for i in range(4):
		var random_index = randi_range(0, all_indices.size() - 1)
		var slice_index = all_indices[random_index]
		all_indices.remove_at(random_index)
		selected_indices.append(slice_index)
	var non_selected_indices = all_indices.duplicate()
	for index in selected_indices:
		non_selected_indices.erase(index)
	expected_boss_indices = non_selected_indices.duplicate()
	shadow_clones = []
	for index in selected_indices:
		var shadow_clone = clone(index)
		shadow_clone.connect("action_completed", _on_shadow_clone_completed)
		shadow_clones.append(shadow_clone)
	#var shadow_clone = clone()
	#shadow_clone.connect("action_completed", _on_shadow_clone_completed)
func clone(slice_index):
	var clone = ShadowCloneScene.instantiate()
	clone.position = owner.center_of_screen
	clone.boss_room_center = owner.center_of_screen
	clone.set_target_slice(slice_index)
	add_child(clone)
	return clone
	
func _on_shadow_clone_completed(slice_indices):
	clones_completed += 1
	if clones_completed == 4:
		current_boss_index = 0
		spawn_bosses()
	#print("Shadow visited slices:", slice_indices)
	#expected_boss_indices = slice_indices.duplicate()
	#current_boss_index = 0
	#spawn_bosses()
	
func spawn_bosses():
	animation_player.play("jump_slam")
	await animation_player.animation_finished
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("sac_mechanic")
	shadow_state_timer.start()
	for index in range(8):
		var boss_clone = BossCloneScene.instantiate()
		boss_clone.position = get_boss_position(index)
		boss_clone.boss_index = index
		get_parent().get_parent().get_parent().add_child(boss_clone)
		boss_clones.append(boss_clone)
		boss_clone.connect("boss_hit", self._on_boss_clone_hit)
		
func get_boss_position(index):
	var offset_distance = 110
	var angle = (index + 0.5) * (TAU / 8) 
	return owner.center_of_screen + Vector2(cos(angle), sin(angle)) * offset_distance
	
func _on_boss_clone_hit(boss_index):
	if boss_index in expected_boss_indices:
		expected_boss_indices.erase(boss_index)
	else:
		var clone_hit = null
		for clone in boss_clones:
			if is_instance_valid(clone) and clone.boss_index == boss_index:
				clone_hit = clone
				break
		if clone_hit != null:
			clone_hit.wrong_sac_explode()
			owner.boss_room_animation.play("arena_aoe_sac")
			trigger_aoe_count += 1
		#trigger_area_attack()
		#cleanup_boss_clones()
	
func cleanup_boss_clones():
	for clone in boss_clones:
		if is_instance_valid(clone):
			clone.play_sac_explode()
			
	await get_tree().create_timer(1.5).timeout
	
	for clone in boss_clones:
		if is_instance_valid(clone):
			clone.queue_free()
	boss_clones.clear()

func trigger_area_attack():
	print("playing raid wide aoe")
	animation_player.play("buff_attack")
	await get_tree().create_timer(0.4165).timeout
	cleanup_boss_clones()
	await get_tree().create_timer(0.0833).timeout
	owner.boss_room_animation.play("arena_aoe")
	await owner.boss_room_animation.animation_finished
	trigger_aoe_count += 1

func transition():
	if can_transition:
		can_transition = false
		await get_tree().create_timer(1).timeout
		get_parent().change_state("Follow")

#func _on_shadow_state_timer_timeout() -> void:
		
func _on_shadow_state_timer_2_timeout() -> void:
	owner.circle_animation.play("circle_disappear")
	if expected_boss_indices.is_empty():
		cleanup_boss_clones()
		
		can_transition = true
	elif trigger_aoe_count == 0:
		trigger_area_attack()







#extends State
#
#var ShadowCloneScene = preload("res://Characters/shadow_player_combo.tscn")
#var BossCloneScene = preload("res://Characters/boss_clone.tscn")
#@onready var shadow_state_timer: Timer = $"../../ShadowStateTimer2"
#var trigger_aoe_count: int = 0
#
#var num_slices = 8
#var all_slices = [0, 1, 2, 3, 4, 5, 6, 7]
#
#var correct_shadow_slices = []
#var wrong_shadow_slices = []
#var boss_clones = []
#var expected_boss_indices = []
#var bosses_spawned = false
#
#var boss_room_center = Vector2.ZERO
#var can_transition: bool = false
#
#func enter():
	#super.enter()
	#animation_player.play("idle_right")
	#owner.boss_charge_animation.play("clone_spawn")
	#await owner.boss_charge_animation.animation_finished
	#owner.circle_animation.play("circle_appear")
	#animation_player.play("jump_away")
	#
	##await animation_player.animation_finished
	#await owner.circle_animation.animation_finished
	##owner.circle_animation.play("circle_flash")
	#spawn_shadow()
	#
#func spawn_shadow():
	##var shadow_clone = clone()
	##shadow_clone.connect("action_completed", _on_shadow_clone_completed)
	#var available_slices = all_slices.duplicate()
	#
	#for i in range(4):
		#var random_index = randi_range(0, available_slices.size() - 1)
		#var slice_index = available_slices[random_index]
		#available_slices.remove_at(random_index)
		#correct_shadow_slices.append(slice_index)
		#
	#wrong_shadow_slices = available_slices.duplicate()
	#print("correct shadow slices ", correct_shadow_slices)
	#print("wrong shadow slices ", wrong_shadow_slices)
	#
	#var correct_shadow = instantiate_shadow(correct_shadow_slices)
	#correct_shadow.connect("action_completed", _on_correct_shadow_completed)
	#
	#var wrong_shadow = instantiate_shadow(wrong_shadow_slices, true)
	#wrong_shadow.connect("action_completed", _on_wrong_shadow_completed)
	#
#func instantiate_shadow(slices_to_visit, is_wrong_shadow = false):
	#var shadow_clone = ShadowCloneScene.instantiate()
	#shadow_clone.position = owner.center_of_screen
	##player.position
	#shadow_clone.boss_room_center = owner.center_of_screen
	#shadow_clone.slices_to_visit = slices_to_visit
	#shadow_clone.is_wrong_shadow = is_wrong_shadow
	#add_child(shadow_clone)
	#
	#return shadow_clone
#
#func _on_correct_shadow_completed(slice_indices):
	#correct_shadow_slices = slice_indices.duplicate()
	#expected_boss_indices = correct_shadow_slices.duplicate()
	#check_if_both_shadows_completed()
	#
#func _on_wrong_shadow_completed(slice_indices):
	#wrong_shadow_slices = slice_indices.duplicate()
	#check_if_both_shadows_completed()
	#
#func check_if_both_shadows_completed():
	#if correct_shadow_slices.size() > 0 and wrong_shadow_slices.size() > 0 and not bosses_spawned:
		#bosses_spawned = true
		#spawn_bosses()
	#
#func spawn_bosses():
	##owner.land_sound()
	##await get_tree().create_timer(0.75).timeout
	##animation_player.play("jump_land")
	#animation_player.play("jump_slam")
	#await animation_player.animation_finished
	#animation_player.play("idle_right")
	#owner.boss_charge_animation.play("sac_mechanic")
	#
	#shadow_state_timer.start()
	#
	#for index in range(num_slices):
		#var boss_clone = BossCloneScene.instantiate()
		#boss_clone.position = get_boss_position(index)
		#boss_clone.boss_index = index
		#print(boss_clone.is_correct_boss)
		#if index in correct_shadow_slices:
			#boss_clone.is_correct_boss = true
		#else:
			#boss_clone.is_correct_boss = false
		#add_child(boss_clone)
		#boss_clones.append(boss_clone)
		#boss_clone.connect("boss_hit", _on_boss_clone_hit)
		#
#func get_boss_position(index):
	#var offset_distance = 110
	#var angle = (index + 0.5) * (TAU / num_slices) 
	#return owner.center_of_screen + Vector2(cos(angle), sin(angle)) * offset_distance
	#
#func _on_boss_clone_hit(boss_index):
	#print("boss_index value: ", boss_index)
	#print("expected_boss_indices: ", expected_boss_indices)
	#if boss_index in expected_boss_indices:
		#expected_boss_indices.erase(boss_index)
	#else:
		#var clone_hit = null
		#for clone in boss_clones:
			#if is_instance_valid(clone) and clone.boss_index == boss_index:
				#clone_hit = clone
				#break
		#if clone_hit != null:
			#clone_hit.wrong_sac_explode()
			#owner.boss_room_animation.play("arena_aoe_sac")
			#trigger_aoe_count += 1
		##cleanup_boss_clones()
	#
#func cleanup_boss_clones():
	#print("cleaning up boss_clones, wrong one hit")
	#for clone in boss_clones:
		#if is_instance_valid(clone):
			#clone.play_sac_explode()
			#
	#await get_tree().create_timer(1).timeout
	#
	#for clone in boss_clones:
		#if is_instance_valid(clone):
			#clone.queue_free()
			#
	#boss_clones.clear()
	#
#func trigger_area_attack():
	#print("playing raid wide aoe")
	#animation_player.play("buff_attack")
	#await get_tree().create_timer(0.4165).timeout
	#cleanup_boss_clones()
	#await get_tree().create_timer(0.0833).timeout
	#owner.boss_room_animation.play("arena_aoe")
	#await owner.boss_room_animation.animation_finished
	##clone.wrong_sac_explode()
	#trigger_aoe_count += 1
#
#func transition():
	#if can_transition:
		#can_transition = false
		#get_parent().change_state("Follow")
#
#func _on_shadow_state_timer_2_timeout() -> void:
	#owner.circle_animation.play("circle_disappear")
	#if expected_boss_indices.is_empty():
		#await get_tree().create_timer(0.5).timeout
		#cleanup_boss_clones()
		#await get_tree().create_timer(1.5).timeout
		##shadow_state_timer.stop()
		#
		##await animation_player.animation_finished
		#
		#can_transition = true
	#elif trigger_aoe_count == 0:
		#trigger_area_attack()
