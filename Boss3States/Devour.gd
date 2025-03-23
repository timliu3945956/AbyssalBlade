extends State

var GoldOrb = preload("res://Other/DevourGold.tscn")
var RedOrb = preload("res://Other/DevourRed.tscn")

var can_transition: bool = false
var boss_room_center = Vector2.ZERO

func enter():
	super.enter()
	animation_player.play("idle")
	owner.attack_meter_animation.play("devour")
	await owner.attack_meter_animation.animation_finished
	animation_player.play("devour_start")
	owner.boss_room.ground_aura()
	await get_tree().create_timer(1).timeout
	
	spawn_orbs()
	await get_tree().create_timer(12).timeout
	owner.boss_room.ground_aura_end()
	animation_player.play("devour_finish")
	await animation_player.animation_finished
	can_transition = true
	
func spawn_orbs():
	var spawn_order = [6, 1, 4, 7, 2, 5, 8, 3] #6, 1, 3, 8, 5, 
	var amount_spawned: int = 0
	for i in spawn_order:
		if amount_spawned % 2 == 0:
			var gold_orb = GoldOrb.instantiate()
			gold_orb.position = get_boss_position(i - 1)
			gold_orb.boss = owner
			get_parent().get_parent().get_parent().add_child(gold_orb)
		else:
			var red_orb = RedOrb.instantiate()
			red_orb.position = get_boss_position(i - 1)
			red_orb.boss = owner
			get_parent().get_parent().get_parent().add_child(red_orb)
		amount_spawned += 1
		await get_tree().create_timer(1).timeout
		
func get_boss_position(index):
	var offset_distance = 140
	var angle = (index) * (TAU / 8)
	return owner.center_of_screen + Vector2(cos(angle), sin(angle)) * offset_distance

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("LoomingHavoc")
		#
		#can_transition = true
	
