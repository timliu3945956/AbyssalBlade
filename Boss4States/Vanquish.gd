extends State

signal clone_telegraph(numerical: String)
signal clone_attack

@export var clone_scene := preload("res://Other/VanquishClone.tscn")
var dash_clones = preload("res://Other/clone_dash.tscn")

const DIRECTIONS := [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
const INDICES := [0, 1, 2, 3]

var clones: Array[Node] = []
var _next_clone_index : int = 0

var can_transition: bool = false

func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	owner.state_machine.travel("Idle")
	owner.attack_meter_animation.play("vanquish")
	await owner.attack_meter_animation.animation_finished
	
	owner.state_machine.travel("invisible")
	spawn_dash()
	await get_tree().create_timer(0.3333).timeout
	
	spawn_clones()
	owner.premonition_symbol_audio.play()
	#owner.premonition_marker_audio.play()
	
	await get_tree().create_timer(3).timeout
	#for _i in 4:
	owner.attack_meter_animation.play("premonition_1")
	await owner.attack_meter_animation.animation_finished
	trigger_clone_telegraph()
	
	owner.attack_meter_animation.play("premonition_2")
	await owner.attack_meter_animation.animation_finished
	trigger_clone_telegraph()
	
	owner.attack_meter_animation.play("premonition_3")
	await owner.attack_meter_animation.animation_finished
	trigger_clone_telegraph()
	
	owner.attack_meter_animation.play("premonition_4")
	await owner.attack_meter_animation.animation_finished
	trigger_clone_telegraph()
	
	player.vfx_timer.stop()
	owner.attack_meter_animation.play("vanquish_attack")
	await get_tree().create_timer(3.4).timeout
	owner.blade_of_ruin_audio.play()
	await owner.attack_meter_animation.animation_finished
	trigger_clone_attack()
	await get_tree().create_timer(1.0).timeout
	await get_tree().create_timer(0.3333).timeout
	owner.animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	owner.state_machine.travel("visible")
	owner.smoke.play("smoke")
	await get_tree().create_timer(0.5).timeout
	
	can_transition = true
	
func spawn_clones() -> void:
	player.tether_vfx_spawn()
	player.vfx_timer.start()
	randomize()
	
	var shuffled := INDICES.duplicate()
	shuffled.shuffle()
	
	for c in clones:
		if is_instance_valid(c):
			c.queue_free()
	clones.clear()
	_next_clone_index = 0
	
	for i in INDICES.size():
		var dir = DIRECTIONS[i]
		var idx = shuffled[i] #0-3
		var c = clone_scene.instantiate()
		
		c.player = player
		c.boss = owner
		get_parent().get_parent().get_parent().add_child(c)
		c.global_position = global_position + dir * 113
		c.set_index(idx)
		
		
		clone_telegraph.connect(c._on_boss_clone_telegraph)
		clone_attack.connect(c._on_boss_clones_attack)
		
		clones.append(c)
		
func trigger_clone_telegraph() -> void:
	if clones.is_empty(): return
	clone_telegraph.emit(INDICES[_next_clone_index])
	
	_next_clone_index = (_next_clone_index + 1) % INDICES.size()
	
func trigger_clone_attack() -> void:
	if clones.is_empty(): return
	clone_attack.emit()
	
func spawn_dash():
	var spawn_dash_clones = dash_clones.instantiate()
	get_parent().get_parent().get_parent().add_child(spawn_dash_clones)
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("AttackCombo")
