extends CharacterBody2D

@export var move_speed : float = 85

enum {
	MOVE
}

var state = MOVE

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var direction_timer: Timer = $DirectionTimer
@onready var smoke: AnimatedSprite2D = $smoke
@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio

var num_slices = 8
var slice_positions = []
var movement_sequence = []
var selected_indices = []

var current_target_index = 0
var target_position = Vector2.ZERO
var is_idling = false
var idle_timer = null

var boss_room_center = Vector2.ZERO
signal action_completed(slice_indices)

var total_time_per_step: float = 2.9988
var time_started_movement: float = 0.0
var time_taken_to_move: float = 0.0
var idle_duration: float = 0.0

func _ready() -> void:
	randomize()
	smoke.play("smoke")
	sprite_2d.material.set_shader_parameter("fade_alpha", 0.5)
	spawn_shadow_audio.play()
	calculate_slice_positions()
	setup_movement_sequence()
	current_target_index = 0
	move_to_next_target()
	
func calculate_slice_positions():
	var center = boss_room_center
	var radius = 114
	slice_positions.clear()
	for i in range(num_slices):
		var angle = (i + 0.5) * (TAU / num_slices)
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		slice_positions.append(pos)

func setup_movement_sequence():
	var available_indices = []
	for i in range(num_slices):
		available_indices.append(i)
	selected_indices = []
	movement_sequence = []
	
	for i in range(4):
		var random_index = randi_range(0, available_indices.size() - 1)
		var slice_index = available_indices[random_index]
		available_indices.remove_at(random_index)
		selected_indices.append(slice_index)
		movement_sequence.append(slice_positions[slice_index])
	print("Shadow will move to slices:", selected_indices)
	
func move_to_next_target():
	if current_target_index < movement_sequence.size():
		target_position = movement_sequence[current_target_index]
		is_idling = false
		time_started_movement = Time.get_ticks_msec() / 1000.0
	else:
		emit_signal("action_completed", selected_indices)
		smoke.play("smoke")
		await get_tree().create_timer(0.0833).timeout
		sprite_2d.material.set_shader_parameter("fade_alpha", 0)
		await get_tree().create_timer(0.4495).timeout
		queue_free()
		
func _physics_process(delta: float) -> void:
	if is_idling:
		velocity = Vector2.ZERO
		state_machine.travel("Idle")
	else:
		move_to_target(delta)
		
func move_to_target(delta):
	var direction = (target_position - position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	# Update animations
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", direction)
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
	# Check if arrived at target position
	if position.distance_to(target_position) < 5:
		start_idling()
		
func start_idling():
	var current_time = Time.get_ticks_msec() / 1000.0
	time_taken_to_move = current_time - time_started_movement
	idle_duration = total_time_per_step - time_taken_to_move
	if idle_duration < 0:
		idle_duration = 0
	is_idling = true
	velocity = Vector2.ZERO
	state_machine.travel("Idle")
	if idle_duration > 0:
		idle_timer = Timer.new()
		idle_timer.wait_time = idle_duration
		idle_timer.one_shot = true
		add_child(idle_timer)
		idle_timer.connect("timeout", self._on_idle_timer_timeout)
		idle_timer.start()
	else:
		_on_idle_timer_timeout()
	
func _on_idle_timer_timeout():
	if idle_timer != null:
		idle_timer.queue_free()
		idle_timer = null
	current_target_index += 1
	move_to_next_target()
