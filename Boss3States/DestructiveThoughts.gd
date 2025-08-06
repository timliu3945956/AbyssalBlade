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
	owner.attack_meter_animation.play("destructive_thoughts")
	await owner.attack_meter_animation.animation_finished
	
	pillar_spawn(owner.center_of_screen + Vector2(-59, -59))
	pillar_spawn_2(owner.center_of_screen + Vector2(59, 59))
	pillar_spawn_3(owner.center_of_screen + Vector2(59, -59))
	pillar_spawn_4(owner.center_of_screen + Vector2(-59, 59))
	await TimeWait.wait_sec(3)#await get_tree().create_timer(3).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await TimeWait.wait_sec(3.5)#await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await TimeWait.wait_sec(3.5)#await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await TimeWait.wait_sec(3.5)#await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	owner.protean_animation_player.play("protean_bait")
	owner.protean_follow_timer.start()
	await TimeWait.wait_sec(3.5)#await get_tree().create_timer(3.5).timeout
	animation_player.play("barrage")
	await owner.protean_animation_player.animation_finished # 4 seconds / 48 frames
	owner.oppressive_audio.play()
	owner.protean_animation_player.play("protean_hit")
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	
	#await for testing if works
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout
	
	

	can_transition = true
	
func pillar_spawn(pillar_position: Vector2):
	owner.pillar = DestructivePillar.instantiate()
	owner.pillar.position = pillar_position
	owner.pillar.player = owner.player
	if pick_random_timer == 1:
		owner.pillar.timer_set = 15.0
	else:
		owner.pillar.timer_set = 25.0
	owner.pillar.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar)
	
func pillar_spawn_2(pillar_position: Vector2):
	owner.pillar_2 = DestructivePillar2.instantiate()
	owner.pillar_2.position = pillar_position
	owner.pillar_2.player = owner.player
	if pick_random_timer == 1:
		owner.pillar_2.timer_set = 15.0
	else:
		owner.pillar_2.timer_set = 25.0
	owner.pillar_2.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_2)
	
func pillar_spawn_3(pillar_position: Vector2):
	owner.pillar_3 = DestructivePillar3.instantiate()
	owner.pillar_3.position = pillar_position
	owner.pillar_3.player = owner.player
	if pick_random_timer == 1:
		owner.pillar_3.timer_set = 25.0
	else:
		owner.pillar_3.timer_set = 15.0
	owner.pillar_3.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_3)
	
func pillar_spawn_4(pillar_position: Vector2):
	owner.pillar_4 = DestructivePillar4.instantiate()
	owner.pillar_4.position = pillar_position
	owner.pillar_4.player = owner.player
	if pick_random_timer == 1:
		owner.pillar_4.timer_set = 25.0
	else:
		owner.pillar_4.timer_set = 15.0
	owner.pillar_4.collision_set = false #true
	get_parent().get_parent().get_parent().add_child(owner.pillar_4)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Phase2")
