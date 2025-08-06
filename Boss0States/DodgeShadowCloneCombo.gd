extends State

var ShadowCloneScene = preload("res://Characters/dodge_shadow_player_combo.tscn")

var can_transition: bool = false
var shadow_clones = []
var shadow_direction_indices = []
var boss_clones = []
var expected_boss_indices = []
var current_boss_index = 0

var boss_room_center = Vector2.ZERO

func enter():
	super.enter()
	animation_player.play("idle_right")
	owner.boss_charge_animation.play("clone_spawn_3")
	await owner.boss_charge_animation.animation_finished
	owner.circle_animation.play("circle_appear")
	
	#owner.boss_charge_animation.play("dodge_shadow_combo")
	spawn_shadow()
	owner.boss_charge_animation.play("phantom_cleave_telegraph_1")
	await owner.boss_charge_animation.animation_finished
	owner.boss_room_animation.play("phantom_cleave_telegraph")
	owner.boss_charge_animation.play("phantom_cleave_telegraph_2")
	await owner.boss_charge_animation.animation_finished
	owner.boss_room_animation.play("phantom_cleave_telegraph")
	owner.boss_charge_animation.play("phantom_cleave_telegraph_3")
	await owner.boss_charge_animation.animation_finished
	owner.boss_room_animation.play("phantom_cleave_telegraph")
	owner.boss_charge_animation.play("phantom_cleave_telegraph_4")
	await owner.boss_charge_animation.animation_finished
	owner.boss_room_animation.play("phantom_cleave_telegraph")
	
	#await owner.circle_animation.animation_finished
	#owner.circle_animation.play("circle_flash")
	#await get_tree().create_timer(1).timeout
	
func spawn_shadow():
	var all_indices: Array = []
	for i in range(8):
		all_indices.append(i)
	var available_indices: Array = all_indices.duplicate()
	
	var selected_correct_indices: Array = []
	for i in range(4):
		var random_index = randi_range(0, available_indices.size() - 1)
		var slice_index = available_indices[random_index]
		available_indices.remove_at(random_index)
		selected_correct_indices.append(slice_index)
		
	var selected_wrong_indices: Array = available_indices.duplicate()
	
	var correct_clone = clone(selected_correct_indices)
	correct_clone.connect("action_completed", _on_shadow_clone_completed)
	shadow_clones.append(correct_clone)
	
	var wrong_clone = clone(selected_wrong_indices, true)
	wrong_clone.connect("action_completed", _on_shadow_clone_completed)
	shadow_clones.append(wrong_clone)
	
	expected_boss_indices = selected_correct_indices.duplicate()
	
func clone(slice_indices: Array, is_wrong_shadow = false):
	var clone = ShadowCloneScene.instantiate()
	clone.position = owner.center_of_screen
	clone.boss_room_center = owner.center_of_screen
	clone.boss = owner
	add_child(clone)
	clone.set_slice_indices(slice_indices)
	clone.is_wrong_shadow = is_wrong_shadow
	return clone

func _on_shadow_clone_completed(slice_indices):
	animation_player.play("jump_away")
	await animation_player.animation_finished
	
	print("Shadow visited slices:", slice_indices)
	await play_animations()
	
func play_animations():
	var idx = 1
	for index in expected_boss_indices:
		var anim_name = "invis_attack_%d" % [idx]
		owner.boss_charge_animation.play(anim_name)
		await owner.boss_charge_animation.animation_finished
		idx += 1
		var animation_name = "safe_slice_" + str(index)
		owner.boss_room_animation.play(animation_name)
		owner.flash_room_animation.play("flash_arena")
		
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.animation_player.play("jump_slam")
	owner.boss_jump_timer.start()
	await animation_player.animation_finished
	animation_player.play("idle_right")
	
	owner.circle_animation.play("circle_disappear")
	#await get_tree().create_timer(1).timeout
	
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
	
