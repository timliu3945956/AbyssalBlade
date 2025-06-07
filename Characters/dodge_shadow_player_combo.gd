extends CharacterBody2D

@export var move_speed : float = 85
@export var is_wrong_shadow: bool = false

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

#var num_slices = 8
var slice_positions: Array = []
var movement_sequence: Array = []
var selected_indices: Array = []

var current_target_index: int = 0
var target_position = Vector2.ZERO

var is_idling = false
var idle_timer = null

var boss_room_center: Vector2 = Vector2.ZERO
signal action_completed(slice_indices: Array)

var total_time_per_step: float = 2.9988
var time_started_movement: float = 0.0
var time_taken_to_move: float = 0.0
var idle_duration: float = 0.0

func _ready() -> void:
	randomize()
	smoke.play("smoke")
	sprite_2d.material.set_shader_parameter("fade_alpha", 0.5)
	spawn_shadow_audio.play()
	#calculate_slice_positions()
	#setup_movement_sequence()
	current_target_index = 0
	#move_to_next_target()
	
func calculate_slice_positions():
	var center = boss_room_center
	var radius = 114.0
	slice_positions.clear()
	for i in range(8):
		var angle = (i + 0.5) * (TAU / 8)
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		slice_positions.append(pos)
		
func set_slice_indices(slice_indices: Array) -> void:
	calculate_slice_positions()
	selected_indices = slice_indices
	movement_sequence = []
	for slice_index in selected_indices:
		movement_sequence.append(slice_positions[slice_index])
	current_target_index = 0
	move_to_next_target()

#func setup_movement_sequence():
	#var available_indices = []
	#for i in range(num_slices):
		#available_indices.append(i)
	#selected_indices = []
	#movement_sequence = []
	#
	#for i in range(4):
		#var random_index = randi_range(0, available_indices.size() - 1)
		#var slice_index = available_indices[random_index]
		#available_indices.remove_at(random_index)
		#selected_indices.append(slice_index)
		#movement_sequence.append(slice_positions[slice_index])
	#print("Shadow will move to slices:", selected_indices)
	
func move_to_next_target():
	if current_target_index < movement_sequence.size():
		target_position = movement_sequence[current_target_index]
		is_idling = false
		time_started_movement = Time.get_ticks_msec() / 1000.0
	else:
		emit_signal("action_completed", selected_indices)
		smoke.play("smoke")
		spawn_shadow_audio.play()
		await get_tree().create_timer(0.0833).timeout
		sprite_2d.material.set_shader_parameter("fade_alpha", 0)
		await get_tree().create_timer(0.4495).timeout
		queue_free()
		
func _physics_process(delta: float) -> void:
	var direction = (target_position - position).normalized()
	if is_idling:
		velocity = Vector2.ZERO
		if is_wrong_shadow and current_target_index >= 2:
			animation_tree.set("parameters/BossIdle/blend_position", direction.x)
			state_machine.travel("BossIdle")
		else:
			state_machine.travel("Idle")
	else:
		move_to_target(delta)
		
func move_to_target(delta):
	var direction = (target_position - position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	# Update animations
	if direction != Vector2.ZERO:
		if is_wrong_shadow and current_target_index >= 2:
			animation_tree.set("parameters/BossWalk/blend_position", direction.x)
			animation_tree.set("parameters/BossIdle/blend_position", direction.x)
			state_machine.travel("BossWalk")
		else:
			animation_tree.set("parameters/Walk/blend_position", direction)
			animation_tree.set("parameters/Idle/blend_position", direction)
			state_machine.travel("Walk")
	else:
		if is_wrong_shadow and current_target_index >= 2:
			animation_tree.set("parameters/BossIdle/blend_position", direction.x)
			state_machine.travel("BossIdle")
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
	if is_wrong_shadow and current_target_index >= 2:
		state_machine.travel("BossIdle")
	else:
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






#extends CharacterBody2D
#
#@export var move_speed : float = 85
#@export var dash_speed = 230 # Increase value for faster dash
#var dash_duration = 0.2
#var dash_time_left = 0.0
#var dash_vector = Vector2.DOWN
#var dash_distance_threshold: float = 30
#
#
#enum {
	#MOVE,
	#DASH,
	#IDLE,
	#TRANSFORM
#}
#
#var state = TRANSFORM
#
#@onready var sprite: Sprite2D = $Sprite2D
#@onready var animation_tree: AnimationTree = $AnimationTree
#@onready var state_machine = animation_tree.get("parameters/playback")
#@onready var direction_timer: Timer = $DirectionTimer
#
#@onready var dash_particles: GPUParticles2D = $DashParticles
#@onready var dash_trail: Line2D = $DashTrail
#@onready var smoke: AnimatedSprite2D = $smoke
#@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio
#
#var num_slices = 8
#var slice_positions = []
#var movement_sequence = []
#var selected_indices = []
#
#var current_target_index = 0
#var target_position = Vector2.ZERO
##var is_idling = false
##var idle_timer = null
#
#var boss_room_center = Vector2.ZERO
#signal action_completed(slice_indices)
#
#var total_time_per_step: float = 1.5
#var time_started_movement: float = 0.0
#var time_taken_to_move: float = 0.0
#var idle_duration: float = 0.0
#var idle_timer = null
#
#func _ready() -> void:
	#randomize()
	#smoke.play("smoke")
	#sprite.material.set_shader_parameter("fade_alpha", 0.5)
	#spawn_shadow_audio.play()
	#calculate_slice_positions()
	#setup_movement_sequence()
	#current_target_index = 0
	#move_to_next_target()
	#state = TRANSFORM
	#
#func calculate_slice_positions():
	#var center = boss_room_center
	#var radius = 114
	#slice_positions.clear()
	#for i in range(num_slices):
		#var angle = (i + 0.5) * (TAU / num_slices)
		#var pos = center + Vector2(cos(angle), sin(angle)) * radius
		#slice_positions.append(pos)
#
#func setup_movement_sequence():
	#var available_indices = []
	#for i in range(num_slices):
		#available_indices.append(i)
	#selected_indices = []
	#movement_sequence = []
	#
	#for i in range(4):
		#var random_index = randi_range(0, available_indices.size() - 1)
		#var slice_index = available_indices[random_index]
		#available_indices.remove_at(random_index)
		#selected_indices.append(slice_index)
		#movement_sequence.append(slice_positions[slice_index])
	#print("Shadow will move to slices:", selected_indices)
	#
#func move_to_next_target():
	#if current_target_index < movement_sequence.size():
		#target_position = movement_sequence[current_target_index]
		#time_started_movement = Time.get_ticks_msec() / 1000.0
		#state = MOVE
		#print(current_target_index)
	#else:
		#emit_signal("action_completed", selected_indices)
		#smoke.play("smoke")
		#await get_tree().create_timer(0.0833).timeout
		#sprite.material.set_shader_parameter("fade_alpha", 0)
		#await get_tree().create_timer(0.4495).timeout
		#queue_free()
		#
#func _physics_process(delta: float) -> void:
	#match state:
		#TRANSFORM:
			#transform_state(delta)
		#DASH:
			#dash_state(delta)
		#MOVE:
			#move_state(delta)
		#IDLE:
			#idle_state(delta)
		#
#func transform_state(delta):
	#velocity = Vector2.ZERO
	#state_machine.travel("transform")
	#await get_tree().create_timer(0.25).timeout
	#await get_tree().create_timer(0.25).timeout
	#state = MOVE
	#
#func dash_animation_start():
	#dash_particles.texture = sprite.texture
	#dash_particles.emitting = true
	#dash_trail.visible = true
	#
#func dash_state(delta):
	##var direction = (target_position - position).normalized()
	#
	#if dash_time_left > 0:
		#dash_time_left -= delta
		#velocity = dash_vector.normalized() * dash_speed
		#state_machine.travel("Dash")
		#move()
	#else:
		#velocity = Vector2.ZERO
		##dash_time_left = dash_duration
		#dash_particles.emitting = false
		#dash_trail.visible = false
		#state = MOVE
	#
	#if position.distance_to(target_position) <= dash_distance_threshold:
		#dash_particles.emitting = false
		#dash_trail.visible = false
		#state = MOVE
		#start_move()
		#
#func start_move():
	#velocity = Vector2.ZERO
	#state_machine.travel("Walk")
#
#func move_state(delta):
	#var direction = (target_position - position).normalized()
	#velocity = direction * move_speed
	#move_and_slide()
	#
	## Update animations
	#if direction != Vector2.ZERO:
		#dash_vector = direction * 2
		#animation_tree.set("parameters/Walk/blend_position", direction)
		#animation_tree.set("parameters/Dash/blend_position", direction)
		#state_machine.travel("Walk")
	#else:
		#state_machine.travel("Idle")
		#
	#if position.distance_to(target_position) > dash_distance_threshold:
		#state = DASH
		#dash_time_left = dash_duration
		#
	## Check if arrived at target position
	#if position.distance_to(target_position) < 2:
		#velocity = Vector2.ZERO
		#state = IDLE
		#start_idling()
		#
#func move():
	#move_and_slide()
	#
#func idle_state(delta):
	#velocity = Vector2.ZERO
	#state_machine.travel("Idle")
#
#func start_idling():
	#var current_time = Time.get_ticks_msec() / 1000.0
	#time_taken_to_move = current_time - time_started_movement
	#idle_duration = total_time_per_step - time_taken_to_move
	#if idle_duration < 0:
		#idle_duration = 0
	#if idle_duration > 0:
		#idle_timer = Timer.new()
		#idle_timer.wait_time = idle_duration
		#idle_timer.one_shot = true
		#add_child(idle_timer)
		#idle_timer.connect("timeout", self._on_idle_timer_timeout)
		#idle_timer.start()
	#else:
		#_on_idle_timer_timeout()
	#
#func _on_idle_timer_timeout():
	#if idle_timer != null:
		#idle_timer.queue_free()
		#idle_timer = null
	#current_target_index += 1
	#move_to_next_target()
		#
