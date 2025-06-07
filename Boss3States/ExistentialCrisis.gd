extends State

var DestructivePillar = preload("res://Other/DepressionPillar.tscn")
var DestructivePillar2 = preload("res://Other/DepressionPillar2.tscn")
var DestructivePillar3 = preload("res://Other/DepressionPillar3.tscn")
var DestructivePillar4 = preload("res://Other/DepressionPillar4.tscn")
var DepressionOrb = preload("res://Other/DepressionOrb.tscn")

var can_transition: bool = false
var pick_random_timer: int = randi_range(1, 2)

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	owner.attack_meter_animation.play("existential_crisis")
	await owner.attack_meter_animation.animation_finished
	
	pillar_spawn(owner.center_of_screen + Vector2(-59, -59))
	pillar_spawn_2(owner.center_of_screen + Vector2(59, 59))
	pillar_spawn_3(owner.center_of_screen + Vector2(59, -59))
	pillar_spawn_4(owner.center_of_screen + Vector2(-59, 59))
	await get_tree().create_timer(3).timeout
	animation_player.play("depressive")
	orb_spawn()
	await get_tree().create_timer(2).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await get_tree().create_timer(2).timeout
	
	owner.oppressive_debuff_count = owner.oppressive_current_count
	owner.oppressive_pick = randi_range(1, 2)
	
	animation_player.play("idle")
	print("seeing what this equals: ", int(0 / 2))
	owner.attack_meter_animation.play("oppressive")
	if owner.oppressive_pick == 1:
		owner.left_color = "white"
		owner.right_color = "black"
		var blk_white_sword_tween = get_tree().create_tween()
		blk_white_sword_tween.tween_property(owner.white_black_swords, "modulate:a", 1, 0.5)
		owner.boss_room.white_black_telegraph_start()
		await get_tree().create_timer(3.5).timeout
		owner.boss_room.white_black_telegraph_end()
		
	elif owner.oppressive_pick == 2:
		owner.left_color = "black"
		owner.right_color = "white"
		var blk_white_sword_tween = get_tree().create_tween()
		blk_white_sword_tween.tween_property(owner.black_white_swords, "modulate:a", 1, 0.5)
		owner.boss_room.black_white_telegraph_start()
		await get_tree().create_timer(3.5).timeout
		owner.boss_room.black_white_telegraph_end()
		
	await owner.attack_meter_animation.animation_finished
	animation_player.play("windup")
	await animation_player.animation_finished
	animation_player.play("oppressive")
	owner.oppressive_audio.play()
	if owner.left_color == "white": #1 means white is left, blk is right,,, 2 means blk is left, white is right
		owner.boss_room_animation.play("oppressive_left_white")
		owner.boss_room_animation2.play("oppressive_right_black")
		owner.sword_animation_player.play("white_black_oppressive")
	else:
		owner.boss_room_animation.play("oppressive_left_black")
		owner.boss_room_animation2.play("oppressive_right_white")
		owner.sword_animation_player.play("black_white_oppressive")
	await owner.boss_room_animation.animation_finished
	
	
	await get_tree().create_timer(0.3).timeout
	if owner.oppressive_debuff_count > owner.oppressive_current_count + 1:
		player.kill_player()
		print("killing player, owner.oppressive_current_count")
	
	owner.oppressive_current_count = owner.oppressive_debuff_count
	animation_player.play("standup")
	var blk_white_sword_tween = get_tree().create_tween()
	var white_blk_sword_tween = get_tree().create_tween()
	blk_white_sword_tween.tween_property(owner.white_black_swords, "modulate:a", 0, 0.5)
	white_blk_sword_tween.tween_property(owner.black_white_swords, "modulate:a", 0, 0.5)
	
	await animation_player.animation_finished
	animation_player.play("idle")
	owner.sword_animation_player.play("swords_idle")
	#owner.oppressive_debuff_count = owner.oppressive_current_count
	#owner.oppressive_pick = randi_range(1, 2)
	#
	#animation_player.play("idle")
	#print("seeing what this equals: ", int(0 / 2))
	#owner.attack_meter_animation.play("oppressive")
	#if owner.oppressive_pick == 1:
		#owner.left_color = "white"
		#owner.right_color = "black"
	#elif owner.oppressive_pick == 2:
		#owner.left_color = "black"
		#owner.right_color = "white"
	#await owner.attack_meter_animation.animation_finished
	#
	#if owner.left_color == "white": #1 means white is left, blk is right,,, 2 means blk is left, white is right
		#owner.boss_room_animation.play("oppressive_left_white")
		#owner.boss_room_animation2.play("oppressive_right_black")
	#else:
		#owner.boss_room_animation.play("oppressive_left_black")
		#owner.boss_room_animation2.play("oppressive_right_white")
	#await owner.boss_room_animation.animation_finished
	#
	#await get_tree().create_timer(0.3).timeout
	#if owner.oppressive_debuff_count > owner.oppressive_current_count + 1:
		#player.kill_player()
		#print("killing player, owner.oppressive_current_count")
	#
	#owner.oppressive_current_count = owner.oppressive_debuff_count
	await get_tree().create_timer(0.2).timeout
	animation_player.play("depressive")
	orb_spawn()
	await get_tree().create_timer(2).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await get_tree().create_timer(4).timeout
	
	
	
	#mechanic ends here
	await get_tree().create_timer(2).timeout
	

	can_transition = true
	
func orb_spawn():
	var orb = DepressionOrb.instantiate()
	orb.position = owner.center_of_screen
	orb.player = owner.player
	get_parent().get_parent().get_parent().add_child(orb)
	
func pillar_spawn(pillar_position: Vector2):
	var pillar = DestructivePillar.instantiate()
	pillar.position = pillar_position
	pillar.player = owner.player
	if pick_random_timer == 1:
		pillar.timer_set = 14.0
	else:
		pillar.timer_set = 27.0
	pillar.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar)
	
func pillar_spawn_2(pillar_position: Vector2):
	var pillar_2 = DestructivePillar2.instantiate()
	pillar_2.position = pillar_position
	pillar_2.player = owner.player
	if pick_random_timer == 1:
		pillar_2.timer_set = 14.0
	else:
		pillar_2.timer_set = 27.0
	pillar_2.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar_2)
	
func pillar_spawn_3(pillar_position: Vector2):
	var pillar_3 = DestructivePillar3.instantiate()
	pillar_3.position = pillar_position
	pillar_3.player = owner.player
	if pick_random_timer == 1:
		pillar_3.timer_set = 27.0
	else:
		pillar_3.timer_set = 14.0
	pillar_3.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar_3)
	
func pillar_spawn_4(pillar_position: Vector2):
	var pillar_4 = DestructivePillar4.instantiate()
	pillar_4.position = pillar_position
	pillar_4.player = owner.player
	if pick_random_timer == 1:
		pillar_4.timer_set = 27.0
	else:
		pillar_4.timer_set = 14.0
	pillar_4.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar_4)

func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("LoomingHavoc")
