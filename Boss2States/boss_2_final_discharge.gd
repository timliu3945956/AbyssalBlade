extends State

var can_transition: bool = false
var LaserBeam = preload("res://Characters/beam.tscn")
var LightningDodge = preload("res://Other/LightningDodge.tscn")
var aoe_count: int = 9

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.position = owner.center_of_screen + Vector2(0, -91)
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	lightning()
	aoe_count += 1
	await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
	lightning()
	aoe_count += 1
	await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
	lightning()
	aoe_count += 1
	await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
	lightning()
	aoe_count += 1
	await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
	lightning()
	aoe_count += 1
	await TimeWait.wait_sec(4)#await get_tree().create_timer(4).timeout
	if owner.boss_death == false:
		can_transition = true
	
#func beam():
	#var beam = LaserBeam.instantiate()
	#beam.position = Vector2(0, -6)
	#beam.rotation = beam.position.angle_to_point(player.position)
	#add_child(beam)
	#print("beam being instantiated")
	
func beam(rotation: Vector2):
	var beam = LaserBeam.instantiate()
	beam.position = Vector2(0, -6)
	beam.rotation = (rotation).angle()
	#beam.position.angle_to_point(player.position)
	add_child(beam)
	print("beam being instantiated")
	
func lightning():
	for i in range(aoe_count):
		# Instance new AOE line
		var aoe = LightningDodge.instantiate()
		add_child(aoe)
		
		# Compute random rotation within 90 degree +- 45 degree
		var random_degrees = randi_range(25, 155)
		var random_radians = deg_to_rad(random_degrees)
		aoe.rotation = random_radians
	#var dodge = LightningDodge.instantiate()
	#add_child(dodge)
	
#func transition():
	#if can_transition:
		#can_transition = false
		#if owner.beam_count == 5:
			#get_parent().change_state("MorphOut")
		#get_parent().change_state("ForwardCleave")
