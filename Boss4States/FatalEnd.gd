extends State

var CircleAOE = preload("res://Characters/circle_aoe.tscn")
var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("debuff")
	await owner.attack_meter_animation.animation_finished
	player.spawn_debuffs()
	player.debuff_bar.debuff_finished.connect(owner.boss_room._on_debuff_finished)
	await get_tree().create_timer(2).timeout
	
	owner.attack_meter_animation.play("spawn_clone")
	owner.state_machine.travel("charge_hope_start")
	await owner.attack_meter_animation.animation_finished
	owner.boss_room.spawn_gold_clone()
	owner.state_machine.travel("charge_hope_finish")
	await get_tree().create_timer(0.7).timeout
	owner.state_machine.travel("jump")
	
	await get_tree().create_timer(0.3).timeout
	owner.jump_audio.play()
	await get_tree().create_timer(1).timeout
	
	owner.attack_meter_animation.play("quake")
	player.beam_circle_quake()
	await owner.attack_meter_animation.animation_finished
	owner.beam_circle()
	#owner.state_machine.travel("down_attack")
	circle()
	await get_tree().create_timer(2).timeout
	owner.attack_meter_animation.play("quake")
	player.beam_circle_quake()
	await owner.attack_meter_animation.animation_finished
	owner.beam_circle()
	#owner.state_machine.travel("down_attack")
	circle()
	await get_tree().create_timer(2).timeout
	owner.attack_meter_animation.play("quake")
	player.beam_circle_quake()
	await owner.attack_meter_animation.animation_finished
	owner.beam_circle()
	#owner.state_machine.travel("down_attack")
	circle()
	await get_tree().create_timer(2).timeout
	owner.attack_meter_animation.play("slamdown")
	player.beam_circle_quake()
	await owner.attack_meter_animation.animation_finished
	owner.position = player.position
	owner.beam_circle()
	owner.state_machine.travel("slamdown")
	
	#owner.state_machine.travel("down_attack")
	await get_tree().create_timer(2).timeout
	owner.eruption_audio.play()
	await get_tree().create_timer(0.5).timeout
	
	can_transition = true
	
func circle():
	if is_instance_valid(player):
		var circleAOE = CircleAOE.instantiate()
		circleAOE.position = player.position
		get_parent().get_parent().get_parent().add_child(circleAOE)
		circleAOE.set_y_sort_enabled(false)

func tether_vfx():
	owner.tether_vfx_spawn()
	owner.vfx_timer.start()
	owner.spawn_tether()
	player.tether_vfx_spawn()
	player.vfx_timer.start()

func tether_stop():
	owner.vfx_timer.stop()
	player.vfx_timer.stop()

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("AttackCombo")
