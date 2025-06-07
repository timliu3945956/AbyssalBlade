extends CharacterBody2D

@export var move_speed : float = 85 #42.5
@export var total_time_per_step: float = 2.1
@export var attack_duration: float = 0.4165
@export var idle_per_slice: float = 0.60

const FIRST_SLICE_BONUS := 0

enum {
	MOVE,
	ATTACK,
	IDLE
}

var state = MOVE

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
#@onready var direction_timer: Timer = $DirectionTimer
@onready var smoke: AnimatedSprite2D = $smoke
@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio

const NUM_SLICES = 8
var slice_positions: Array[Vector2] = []
var movement_indices: Array[int] = []
var attack_targets: Array[int] = []
var selected_indices: Array[int] = []
var visit_order: Array[int] = []

var start_slice: int = 0
var walk_dir: int = 1

var current_target_index = 0
var target_position = Vector2.ZERO

var boss_room_center = Vector2.ZERO
signal action_completed(hit_slices, first_slice, walk_dir)

var time_started_movement: float = 0.0
var time_taken_to_move: float = 0.0
var time_taken_for_attack: float = 0.0
var idle_duration: float = 0.0
var idle_timer: Timer = null

func _ready() -> void:
	randomize()
	smoke.play("smoke")
	sprite_2d.material.set_shader_parameter("fade_alpha", 0.5)
	spawn_shadow_audio.play()
	
	start_slice = randi() % NUM_SLICES
	if randi() % 2 == 0:
		walk_dir = 1
	else:
		walk_dir = -1
	
	for i in range(NUM_SLICES):
		movement_indices.append((start_slice + i * walk_dir + NUM_SLICES) % NUM_SLICES)
		
	attack_targets = movement_indices.duplicate()
	attack_targets.shuffle()
	attack_targets.resize(4)
	
	for idx in movement_indices:
		slice_positions.append(_slice_to_position(idx))
		
	target_position = slice_positions[0]
	current_target_index = 0
	state = MOVE
	time_started_movement = Time.get_ticks_msec() / 1000.0
		
func _slice_to_position(idx: int) -> Vector2:
	var radius = 114.0
	var angle = (idx + 0.5) * (TAU / NUM_SLICES)
	return boss_room_center + Vector2(cos(angle), sin(angle)) * radius

func _physics_process(delta: float) -> void:
	match state:
		MOVE: _move_state(delta)
		ATTACK: pass#_attack_state()
		IDLE: pass#_idle_state()
		
func _move_state(delta: float) -> void:
	var dir = (target_position - position).normalized()
	velocity = dir * move_speed
	#position += velocity * delta
	move_and_slide()
	
	animation_tree.set("parameters/Walk/blend_position", dir)
	state_machine.travel("Walk" if dir != Vector2.ZERO else "Idle")
	
	if position.distance_to(target_position) < 2:
		time_taken_to_move = Time.get_ticks_msec() / 1000.0 - time_started_movement
		var cur_slice = movement_indices[current_target_index]
		visit_order.append(cur_slice)
		print(cur_slice)
		if cur_slice in attack_targets:
			state = ATTACK
			#_start_idling(false)
			_perform_attack(cur_slice)
		else:
			state = IDLE
			_start_idling(true)
			
func _perform_attack(cur_slice: int) -> void:
	#var real_attack_duration = animation_tree.get_root_motion_track_position().get_animation_length()
	animation_tree.set("parameters/Attack/blend_position", target_position - position)
	state_machine.travel("Attack")
	
	await get_tree().create_timer(attack_duration).timeout #attack_duration
	
	selected_indices.append(cur_slice)
	
	state = IDLE
	#animation_tree.set("parameters/Idle/blend_position", target_position - position)
	_start_idling(false)

func _attack_state() -> void:
	velocity = Vector2.ZERO
	animation_tree.set("parameters/Attack/blend_position", target_position - position)
	state_machine.travel("Attack")

	await get_tree().create_timer(attack_duration).timeout
	var cur_slice = movement_indices[current_target_index]
	selected_indices.append(cur_slice)

	# now idle (already queued in _start_idling)
	state = IDLE

func _idle_state() -> void:
	velocity = Vector2.ZERO

func _start_idling(after_attack: bool) -> void:
	animation_tree.set("parameters/Idle/blend_position", target_position - position)
	state_machine.travel("Idle")
	
	var bonus: float
	if current_target_index == 0:
		bonus = FIRST_SLICE_BONUS
	else:
		bonus = 0.0
		
	var wait := total_time_per_step + bonus - time_taken_to_move
	if not after_attack:
		wait -= attack_duration
	if wait < 0.0:
		time_started_movement += -wait
		wait = 0.0
		
	#var wait := idle_per_slice if after_attack else (total_time_per_step - time_taken_to_move - attack_duration)
	#if wait < 0.0: wait = 0.0
	
	idle_timer = Timer.new()
	idle_timer.wait_time = wait
	idle_timer.one_shot  = true
	add_child(idle_timer)
	idle_timer.connect("timeout", self._on_idle_timeout)
	idle_timer.start()
	
func _on_idle_timeout() -> void:
	if idle_timer:
		idle_timer.queue_free()
		idle_timer = null
	
	current_target_index += 1
	if current_target_index >= NUM_SLICES:
		_emit_and_vanish()
	else:
		target_position      = slice_positions[current_target_index]
		time_started_movement = Time.get_ticks_msec() / 1000.0
		state = MOVE
	print("slice length =", Time.get_ticks_msec() / 1000.0 - time_started_movement)
		
func _emit_and_vanish() -> void:
	emit_signal("action_completed", selected_indices, start_slice, walk_dir, visit_order)
	smoke.play("smoke")
	spawn_shadow_audio.play()
	await get_tree().create_timer(0.0833).timeout
	sprite_2d.material.set_shader_parameter("fade_alpha", 0.0)
	await get_tree().create_timer(0.45).timeout
	queue_free()
