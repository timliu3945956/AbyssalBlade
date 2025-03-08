extends State

var ShadowCloneScene = preload("res://Characters/dodge_shadow_player.tscn")

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
	owner.boss_charge_animation.play("clone_spawn")
	await owner.boss_charge_animation.animation_finished
	owner.circle_animation.play("circle_appear")
	
	owner.boss_charge_animation.play("dodge_shadow")
	spawn_shadow()
	
	#await owner.circle_animation.animation_finished
	#owner.circle_animation.play("circle_flash")
	#await get_tree().create_timer(1).timeout
	
	
func spawn_shadow():
	var shadow_clone = clone()
	shadow_clone.connect("action_completed", _on_shadow_clone_completed)
	
func _on_shadow_clone_completed(slice_indices):
	animation_player.play("jump_away")
	await animation_player.animation_finished
	
	print("Shadow visited slices:", slice_indices)
	await play_animations(slice_indices)
	
func play_animations(slice_indices):
	for index in slice_indices:
		await get_tree().create_timer(2.9988).timeout
		var animation_name = "safe_slice_" + str(index)
		owner.boss_room_animation.play(animation_name)
		owner.flash_room_animation.play("flash_arena")
		
	await get_tree().create_timer(1).timeout
	
	owner.animation_player.play("jump_slam")
	owner.boss_jump_timer.start()
	await animation_player.animation_finished
	animation_player.play("idle_right")
	
	owner.circle_animation.play("circle_disappear")
	#await get_tree().create_timer(1).timeout
	
	can_transition = true
	
func clone():
	var clone = ShadowCloneScene.instantiate()
	clone.position = owner.center_of_screen
	#player.position
	clone.boss_room_center = owner.center_of_screen
	add_child(clone)
	return clone
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
	
