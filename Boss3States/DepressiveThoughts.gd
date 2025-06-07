extends State

var DepressionPillar = preload("res://Other/DepressionPillar.tscn")
var DepressionPillar2 = preload("res://Other/DepressionPillar2.tscn")
var DepressionOrb = preload("res://Other/DepressionOrb.tscn")

var can_transition: bool = false
var pick_random_timer: int = randi_range(1, 2)

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	set_process_input(true)
	owner.attack_meter_animation.play("depressive_thoughts")
	await owner.attack_meter_animation.animation_finished
	
	pillar_spawn(owner.center_of_screen + Vector2(-59, -59))
	pillar_spawn_2(owner.center_of_screen + Vector2(59, 59))
	await get_tree().create_timer(3).timeout
	
	animation_player.play("depressive")
	orb_spawn()
	await get_tree().create_timer(10).timeout
	
	animation_player.play("depressive")
	orb_spawn()
	await get_tree().create_timer(10).timeout
	
	#mechanic ends here
	
	await get_tree().create_timer(1).timeout
	
	

	can_transition = true
	
func orb_spawn():
	var orb = DepressionOrb.instantiate()
	orb.position = owner.center_of_screen
	orb.player = owner.player
	get_parent().get_parent().get_parent().add_child(orb)
	
func pillar_spawn(pillar_position: Vector2):
	var pillar = DepressionPillar.instantiate()
	pillar.position = pillar_position
	pillar.player = player
	if pick_random_timer == 1:
		pillar.timer_set = 13.0
	else:
		pillar.timer_set = 23.0
	pillar.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar)

func pillar_spawn_2(pillar_position: Vector2):
	var pillar_2 = DepressionPillar2.instantiate()
	pillar_2.position = pillar_position
	pillar_2.player = player
	if pick_random_timer == 1:
		pillar_2.timer_set = 23.0
	else:
		pillar_2.timer_set = 13.0
	pillar_2.collision_set = false
	get_parent().get_parent().get_parent().add_child(pillar_2)

func transition():
	if can_transition:
		can_transition = false
		
		get_parent().change_state("Barrage")
