extends CharacterBody2D

@export var move_speed : float = 85
@export var dash_speed = 230 # Increase value for faster dash
var dash_duration = 0.2
var dash_time_left = 0.0
var can_dash: bool = true

var radius = 5
var controller_aim_direction = Vector2.ZERO
@onready var controller_cursor: Sprite2D = $Smoothing2D/ControllerCursor

# Knockback added code
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.25 #0.15
var knockback_time_left = 0.0
var knockback_damping = 350 #400

enum {
	MOVE,
	DASH,
	ATTACK,
	HEAVYATTACK,
	CHARGE,
	TRANSFORM,
	KNOCKBACK,
	#SHIELD,
	DEATH
}

var state = MOVE

var dash_vector = Vector2.DOWN
var damage_amount : int = 100
var can_attack: bool = true
var transformed: bool = false
var is_transforming: bool = false

var buffered_transform_input = false
var transform_allowed_states = [MOVE, CHARGE]
#, SHIELD

#var can_move = true

var death = false

var heavy_attack_velocity = Vector2.ZERO
var heavy_attack_time = 0.0
var heavy_attack_duration = 0.7

var can_left_click = false
var can_right_click = false

var last_input_was_mouse: bool = true

@onready var sprite: Sprite2D = $Smoothing2D/Sprite2D
@onready var transform_sprite: Sprite2D = $Smoothing2D/Transform

@onready var gpu_particles_2d: GPUParticles2D = $Smoothing2D/GPUParticles2D

@onready var laser_line_left: GPUParticles2D = $CanvasLayer/LaserLineLeft
@onready var ghostly_effect_right: GPUParticles2D = $CanvasLayer/GhostlyEffectRight
@onready var laser_line_right: GPUParticles2D = $CanvasLayer/LaserLineRight
@onready var ghost_effect_left: GPUParticles2D = $CanvasLayer/GhostEffectLeft

@onready var charge_fire_back_layer: GPUParticles2D = $ChargeFireBackLayer
@onready var charge_fire: GPUParticles2D = $ChargeFire

@onready var hurtbox_slash: CollisionShape2D = $HurtboxSlash/CollisionShape2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var hurtbox_slash_collision: CollisionShape2D = $HurtboxSlash/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var camera: Camera2D = $Camera2D

@onready var flash_timer: Timer = $FlashTimer

@onready var hit: AudioStreamPlayer2D = $hit
@onready var heavy_hit: AudioStreamPlayer2D = $"heavy hit"
@onready var abyssal_surge_hit: AudioStreamPlayer2D = $"abyssal surge hit"
@onready var swing: AudioStreamPlayer2D = $swing
@onready var dash: AudioStreamPlayer2D = $dash
@onready var transform_audio: AudioStreamPlayer2D = $transform
@onready var untransform_audio: AudioStreamPlayer2D = $untransform
@onready var surge_ready: AudioStreamPlayer2D = $"surge ready"
@onready var charge: AudioStreamPlayer2D = $charge

@onready var footsteps: AudioStreamPlayer2D = $footsteps
@onready var footstep_timer: Timer = $FootstepTimer

@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var dash_trail: Line2D = $DashTrail

@onready var dash_cooldown: Timer = $Dash_Cooldown
@onready var attack_cooldown: Timer = $Attack_Cooldown
@onready var dash_restore_timer: Timer = $Dash_Restore
@onready var dash_meter: ProgressBar = $CanvasLayer/DashMeter

#@onready var dash_cooldown_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton3/Cooldown
#@onready var heavy_attack_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton2/Cooldown
#@onready var charge_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton4/Cooldown
#@onready var transform_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton5/Cooldown
@onready var heavy_attack_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton2/Cooldown
@onready var dash_cooldown_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton3/Cooldown
@onready var charge_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton4/Cooldown
@onready var transform_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton5/Cooldown

@onready var skill_bar: HBoxContainer = $CanvasLayer/SkillBar


@onready var particles = [
	$CanvasLayer/DashCharge1,
	$CanvasLayer/DashCharge2,
	$CanvasLayer/DashCharge3
]

@onready var transform_time: Timer = $Transform_Time
@onready var transform_time_left: Label = $CanvasLayer/Label

@onready var healthbar: ProgressBar = $CanvasLayer/Healthbar
@onready var manabar: ProgressBar = $CanvasLayer/Manabar

@onready var mana_bar_fire: GPUParticles2D = $CanvasLayer/Manabar/ManaDamageBar/ManaBarFire
@onready var mana_damage_bar: ProgressBar = $CanvasLayer/Manabar/ManaDamageBar
@onready var transform_fire_bar: GPUParticles2D = $CanvasLayer/TransformFireBar
@onready var transform_fire_ball: GPUParticles2D = $CanvasLayer/TransformFireBar/TransformFireBall

@onready var time: Label = $CanvasLayer/Time

@onready var full_charge: GPUParticles2D = $FullCharge
@onready var cursor_aim: Marker2D = $Smoothing2D/CursorAim
@onready var boss_2 = get_node("../Boss2")

var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
var beam_bar_meteor = preload("res://Utilities/cast bar/BeamCircle/beam_progress_meteor.tscn")
var circle_ref: Node2D


#var health = 100 : set = _set_health
var health = 1
var mana = 0 : set = _set_mana # 20
var attack_count = 0
var dash_gauge = 3
var max_dash_gauge = 3
var input_direction: Vector2 = Vector2.ZERO
var last_direction_input: Vector2

@onready var testing_area = get_parent().get_node("../Panel2")

func _ready():
	print(get_tree().get_current_scene())
	animation_tree.active = true
	dash_trail.visible = false
	charge_icon.value = 100
	#print(mana_bar_fire.process_material.emission_box_extents)
	count_dash_gauge()
	manabar.init_mana(mana)
	sprite.show()
	#print("Turning sprite visible and transform invisible")
	transform_sprite.hide()
	
	# Resetting sprite's shader material to 0 for bug
	sprite.material.set_shader_parameter("flash_modifier", 0)
	transform_sprite.material.set_shader_parameter("flash_modifier", 0)
	
	gpu_particles_2d.emitting = false
	laser_line_left.emitting = false
	laser_line_right.emitting = false
	ghost_effect_left.emitting = false
	ghostly_effect_right.emitting = false
	mana_bar_fire.emitting = false # this was uncommented earlier
	mana_bar_fire.process_material.color.a = 1.0
	transform_fire_bar.emitting = false
	transform_fire_ball.emitting = false
	dash_particles.emitting = false
	transform_time_left.visible = false
	
	time.visible = false
	
	hurtbox_slash_collision.call_deferred("set", "disabled", false)
	hurtbox_collision.call_deferred("set", "disabled", false)
	
	var current_scene = get_tree().get_current_scene()
	if current_scene.name == "Settings":
		GlobalCount.is_mouse_in_panel = false
	else:
		GlobalCount.is_mouse_in_panel = true
		
	dash_meter.value = 100
	
	if get_tree().get_current_scene().name == "Settings":
		skill_bar.visible = false

func _process(delta):
	var elapsed_time = GlobalCount.elapsed_time
	
	var minutes = int(elapsed_time) / 60 # Total minutes
	var seconds = int(elapsed_time) % 60 # Remaining seconds
	var milliseconds = int((elapsed_time - int(elapsed_time)) * 100)
	var time_string = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	if GlobalCount.timer_active:
		time.visible = true
		time.text = time_string

func _physics_process(delta):
	if InputCheck.is_mouse:
		input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		input_direction = input_direction.normalized()
	else:
		input_direction = Input.get_vector("left", "right", "up", "down")
		input_direction = input_direction.normalized()
		if input_direction.length() > 0:
			input_direction = input_direction.normalized()
	# Reads right analog stick input
	var right_stick_input = Vector2(
		Input.get_joy_axis(0, 2),
		Input.get_joy_axis(0, 3)
	)
	if !InputCheck.is_mouse:
		controller_aim_direction = right_stick_input
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if controller_aim_direction.length() >= 0.2:
			controller_aim_direction = right_stick_input.normalized()
			
			last_direction_input = controller_aim_direction
			cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position)
			
		#elif input_direction.length() >= 0.2:
			#controller_aim_direction = input_direction
			#last_direction_input = controller_aim_direction
		##cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position)
			#cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position) #this was input_direction
		else:
			controller_aim_direction = last_direction_input
			cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position)
	else:
		controller_aim_direction = (get_global_mouse_position() - global_position).normalized()
		cursor_aim.rotation = cursor_aim.global_position.angle_to_point(get_global_mouse_position())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if Input.is_action_just_pressed("transform") and mana >= 20 and !transformed:
		buffered_transform_input = true
	
	######## Knockback added code
	if state == KNOCKBACK:
		if knockback_time_left > 0:
			knockback_time_left -= delta
			velocity = knockback_velocity
			 #* 2
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_damping * delta)
			
			dash_particles.emitting = false
			dash_trail.visible = false
			charge_fire_back_layer.emitting = false
			charge_fire.emitting = false
			
			move_and_slide()
			if is_transforming: # removed part for bug fixing
				transform_timer()
			else:
				state_machine.travel("Idle")
			#if knockback_time_left <= 0: #removed code for transform bug fix
				#move_speed = 85
				#state = MOVE
		#else:
		#added code for transformation bug
		else:
			move_speed = 85
			if is_transforming:
				state = TRANSFORM
				transform_timer()
			else:
				state = MOVE
	elif !death:
			match state:
				#KNOCKBACK:
					#state_machine.travel("Idle")
					#await get_tree().create_timer(1).timeout
				MOVE:
					move_state(delta)
				DASH:
					dash_state(delta)
				ATTACK:
					attack_state(delta)
				HEAVYATTACK:
					heavy_attack_state(delta)
				CHARGE:
					charge_state(delta)
				TRANSFORM:
					transform_state(delta)
				#SHIELD:
					#shield_state(delta)
					
	else:
		state = DEATH
		play_death()
		
	if state != KNOCKBACK:
		process_input_buffer()
		
	if dash_meter.value >= 100:
		can_dash = true
	
#func _set_health(value):
	#print(health)
	#health = value
	#healthbar.health = health
	#
	#if health <= 0:
		#play_death()
		#var animation_length = animation_player.get_animation("death").length
		#await get_tree().create_timer(animation_length).timeout
		#sprite.queue_free()
		
func _set_mana(value):
	#var tween = get_tree().create_tween()
	#tween.tween_property(manabar, "value", mana+1, 0.5).set_trans(Tween.TRANS_LINEAR)
	mana = value
	#damage_bar.value = manabar.value
	manabar.mana = mana
		
# Knockback function for pushing player away from center
func apply_knockback(source_position: Vector2, force: float):
	if death == false:
		var knockback_direction = (global_position - source_position).normalized()
		knockback_velocity = knockback_direction * force
		knockback_time_left = knockback_duration
		state = KNOCKBACK
		
#func get_aim_direction():
	#return controller_cursor.position.normalized()

func move_state(delta):
			
	if input_direction != Vector2.ZERO:
		dash_vector = input_direction*2
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Dash/blend_position", input_direction)
		state_machine.travel("Walk")
		velocity = input_direction * move_speed
		if footstep_timer.time_left <= 0 and knockback_time_left <= 0:
			footsteps.pitch_scale = randi_range(0.8, 1.2)
			footsteps.play()
			footstep_timer.start()
		#velocity = Input.get_vector("right", "left", "down", "up").normalized() * move_speed
	else:
		state_machine.travel("Idle")
		velocity = Vector2.ZERO
	
	var transform_time_left_int = int(transform_time.time_left)
	transform_time_left.text = str(transform_time_left_int)
	
	
		
	move()
	if transformed:
		dash_gauge = 3
	count_dash_gauge()
	
	if knockback_time_left > 0:
		state = KNOCKBACK
	else:
		if Input.is_action_pressed("dash") and can_dash:
		#and dash_meter.value >= 100:
			dash_time_left = dash_duration
			state = DASH
			dash.play()
			#dash_cooldown.start()
			#if transformed:
				#dash_restore_timer.stop()
				#dash_cooldown.stop()
				#can_dash = true
				#dash_meter.value = 100
			#else:
			can_dash = false
				#dash_cooldown.start()
			dash_meter.value = 0
			restore_dash()
				#if dash_restore_timer.is_stopped():
					#dash_restore_timer.start()
				
			count_dash_gauge()
			
		elif Input.is_action_pressed("attack") and can_attack and GlobalCount.is_mouse_in_panel:
			animation_tree.set("parameters/Attack/Attack/blend_position", controller_aim_direction)
			animation_tree.set("parameters/Idle/blend_position", controller_aim_direction)
			
			state = ATTACK
			swing.play()
			if !transformed:
				can_attack = false
				attack_cooldown.start()
			else:
				attack_cooldown.stop()
				
				count_dash_gauge()
			#GlobalCount.slash_count += 1
			
		if Input.is_action_pressed("heavyattack") and !transformed and GlobalCount.is_mouse_in_panel:
			animation_tree.set("parameters/HeavyAttack/blend_position", controller_aim_direction)
			animation_tree.set("parameters/Idle/blend_position", controller_aim_direction)
			state = HEAVYATTACK
			move_speed = move_speed / 2
			#dash_gauge -= 1
			count_dash_gauge()
			
			
		if Input.is_action_pressed("charge") and !transformed and mana < 20 and !GlobalCount.can_pause:
			animation_tree.set("parameters/Charge/blend_position", animation_tree.get("parameters/Idle/blend_position"))
			state = CHARGE
			charge.play()
		
		if Input.is_action_just_pressed("transform") and mana >= 20 and !transformed:
			animation_tree.set("parameters/Attack/TimeScale/scale", 1.5)
			state = TRANSFORM
			
			
		#if Input.is_action_just_pressed("shield"):
			#state = SHIELD
			
		#print(mana)
		
func dash_state(delta):
	if dash_time_left > 0:
		dash_time_left -= delta
		
		var new_input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		
		if new_input != Vector2.ZERO:
			dash_vector = new_input
			
		
		velocity = dash_vector.normalized() * dash_speed
		state_machine.travel("Dash")
		move()
	else:
		if knockback_time_left <= 0:
			velocity = Vector2.ZERO
		dash_particles.emitting = false
		dash_trail.visible = false
		state = MOVE
		
func count_dash_gauge():
	for i in range(max_dash_gauge):
		particles[i].emitting = i < dash_gauge

func attack_state(delta):
	 #Attack Canceling
	#var aim_direction = get_aim_direction()
	if Input.is_action_pressed("dash") and can_dash and dash_meter.value >= 100:
		#var input_direction = Vector2(
		#Input.get_action_strength("right") - Input.get_action_strength("left"),
		#Input.get_action_strength("down") - Input.get_action_strength("up")
		#)
		input_direction = input_direction.normalized()
		
		if input_direction == Vector2.ZERO:
			input_direction = (get_global_mouse_position() - global_position).normalized()
			
		dash_vector = input_direction * 2
		animation_tree.set("parameters/Dash/blend_position", input_direction)
		dash_time_left = dash_duration
		state = DASH
		
		dash.play()
		#dash_cooldown.start()
		#if transformed:
			#dash_restore_timer.stop()
			#dash_cooldown.stop()
			#can_dash = true
			#dash_meter.value = 100
		#else:
		can_dash = false
			#dash_cooldown.start()
		dash_meter.value = 0
		restore_dash()
			#if dash_restore_timer.is_stopped():
				#dash_restore_timer.start()
			
		#count_dash_gauge()
		state_machine.travel("Dash")
	else:
		if knockback_time_left > 0:
			state = KNOCKBACK
		else:
			if !transformed:
				#var input_direction = Vector2(
				#Input.get_action_strength("right") - Input.get_action_strength("left"),
				#Input.get_action_strength("down") - Input.get_action_strength("up")
				#)
				input_direction = input_direction.normalized()
				velocity = input_direction * move_speed
			else:
				velocity = Vector2.ZERO #commented out for move while attacking test
			state_machine.travel("Attack")
	#if Input.is_action_pressed("attack") and transformed and can_attack:
		#state = ATTACK
	move()
	#print("slash count ", GlobalCount.slash_count)
	#print("dash count ", GlobalCount.dash_count)
	#print("surge count ", GlobalCount.surge_count)
	#print("time count ", GlobalCount.elapsed_time)

func heavy_attack_state(delta):
	#var input_direction = Vector2(
		#Input.get_action_strength("right") - Input.get_action_strength("left"),
		#Input.get_action_strength("down") - Input.get_action_strength("up")
		#)
	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed
	move_speed = max(move_speed - (40.48 * delta), 0) #45.53

	if Input.is_action_pressed("dash") and can_dash:
	#and dash_meter.value >= 100:
		move_speed = 85
		input_direction = input_direction.normalized()
		
		if input_direction == Vector2.ZERO:
			input_direction = (get_global_mouse_position() - global_position).normalized()
			
		dash_vector = input_direction * 2
		animation_tree.set("parameters/Dash/blend_position", input_direction)
		
		dash_time_left = dash_duration
		state = DASH
		dash.play()
		can_dash = false
		dash_meter.value = 0
		restore_dash()
			
		count_dash_gauge()
		state_machine.travel("Dash")
	elif Input.is_action_just_pressed("transform") and mana >= 20 and !transformed:
			animation_tree.set("parameters/Attack/TimeScale/scale", 1.5)
			state = TRANSFORM
	else:
		state_machine.travel("HeavyAttack")
	move()
	
	
func heavy_attack_hit():
	swing.play()
	#GlobalCount.camera.apply_shake(3.0, 20.0)
func heavy_attack_finish():
	move_speed = 85
	
func charge_state(delta):
	velocity = Vector2.ZERO
	state_machine.travel("Charge")
	charge_fire_back_layer.emitting = true
	charge_fire.emitting = true
	if GlobalCount.can_pause == true:
		mana += 20
		full_charge.emitting = true
		mana_bar_fire.process_material.color.a = 1.0
		mana_bar_fire.emitting = true
		await get_tree().create_timer(0.2).timeout
		state = MOVE
	elif mana < 20:
		mana += (delta * 2)
		if mana >= 20:
			surge_ready.play()
			mana_bar_fire.process_material.color.a = 1.0
			mana_bar_fire.emitting = true
	elif death:
		mana += 0
		charge_fire_back_layer.emitting = false
		charge_fire.emitting = false
		state = MOVE
	#else:
	if mana >= 20:
		charge_icon.value = 100 #disable charge icon UI
		transform_icon.value = 0
		charge_fire_back_layer.emitting = false
		charge_fire.emitting = false
		state = MOVE
		
	if Input.is_action_just_released("charge"):
		charge_fire_back_layer.emitting = false
		charge_fire.emitting = false
		state = MOVE
		
	count_dash_gauge()

func transform_state(delta):
	velocity = Vector2.ZERO
	
	state_machine.travel("transform")
	heavy_attack_icon.value = 100
	transform_icon.value = 100
	get_tree().create_timer(0.25).timeout
	gpu_particles_2d.emitting = true
	transformed = true
	transform_fire_bar.emitting = true
	#transform_time_left.visible = true
	transform_fire_ball.emitting = true
	is_transforming = true
	move_speed = 85
	
func process_input_buffer():
	if buffered_transform_input:
		if mana >= 20 and !transformed:
			if state in transform_allowed_states:
				animation_tree.set("parameters/Attack/TimeScale/scale", 1.5)
				state = TRANSFORM
				buffered_transform_input = false
				print("Buffered input transform")
			else:
				pass
		else:
			buffered_transform_input = false
	
#func shield_state(delta):
	#state_machine.travel("Shield")
	#
	#state = MOVE
	#move()

func move():
	move_and_slide()
	
# For dash ghost, connected to AnimationPlayer key
func dash_animation_start():
	dash_particles.texture = sprite.texture
	dash_particles.emitting = true
	dash_trail.visible = true
	
	GlobalCount.dash_count += 1
	
#func dash_animation_finished():
	#velocity = Vector2.ZERO
	#state = MOVE
	#
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transform":
		transform_timer()
		#is_transforming = false
		#sprite.hide()
		#transform_sprite.show()
		#transform_time.start()
		#damage_amount *= 1.6
		#
		#
		#laser_line_left.emitting = true
		#laser_line_right.emitting = true
		#ghost_effect_left.emitting = true
		#ghostly_effect_right.emitting = true
		#
		#print(transform_fire_bar.position)
		##print(manabar.position.x)
		#transform_fire_bar.position = Vector2(manabar.position.x + 144.945, manabar.position.y + 2)
		#print(transform_fire_bar.position)
		#var fire_bar_tween = get_tree().create_tween()
		#var end_position = transform_fire_bar.get_position() - Vector2(manabar.get_rect().size.x+3, 0)
		#fire_bar_tween.tween_property(transform_fire_bar, "position", end_position, 5).set_trans(Tween.TRANS_LINEAR)
		#
		#var manabar_tween = get_tree().create_tween()
		#manabar_tween.tween_property(manabar, "value", 0, 5).set_trans(Tween.TRANS_LINEAR)
		#
		#var mana_damage_bar_tween = get_tree().create_tween()
		#mana_damage_bar_tween.tween_property(mana_damage_bar, "value", 0, 5).set_trans(Tween.TRANS_LINEAR)
		#
		#var mana_bar_fire_tween = get_tree().create_tween()
		#mana_bar_fire_tween.tween_property(mana_bar_fire.process_material, "color:a", 0, 5).set_trans(Tween.TRANS_LINEAR)
		#
		#GlobalCount.surge_count += 1
		#state = MOVE
	#elif anim_name == "attack_left" or anim_name == "attack_right" or anim_name == "attack_up" or anim_name == "attack_down" or anim_name == "attack_down_right" or anim_name == "attack_down_left" or anim_name == "attack_up_right" or anim_name == "attack_up_left":
		#if transformed and Input.is_action_pressed("attack"):
			#print("here going back to attack")
			#state_machine.stop()
			#animation_player.seek(0, true)
			#animation_tree.set("parameters/Attack/Attack/blend_position", get_global_mouse_position() - global_position)
			#animation_tree.set("parameters/Idle/blend_position", get_global_mouse_position() - global_position)
			#swing.play()
			#state = ATTACK
		#else:
			#state = MOVE
		
	if anim_name == "heavy_left" or anim_name == "heavy_right" or anim_name == "heavy_down" or anim_name == "heavy_up":
		move_speed = 85
		state = MOVE
	#else:
	
	#if Input.is_action_pressed("attack") and transformed:
		#state = ATTACK
	#else:
	state = MOVE
	#process_input_buffer()

func transform_timer():
	is_transforming = false
	sprite.hide()
	transform_sprite.show()
	transform_time.start()
	damage_amount *= 1.5
	
	
	laser_line_left.emitting = true
	laser_line_right.emitting = true
	ghost_effect_left.emitting = true
	ghostly_effect_right.emitting = true
	
	print(transform_fire_bar.position)
	#print(manabar.position.x)
	transform_fire_bar.position = Vector2(manabar.position.x + 144.945, manabar.position.y + 2)
	print(transform_fire_bar.position)
	var fire_bar_tween = get_tree().create_tween()
	var end_position = transform_fire_bar.get_position() - Vector2(manabar.get_rect().size.x+3, 0)
	fire_bar_tween.tween_property(transform_fire_bar, "position", end_position, 5).set_trans(Tween.TRANS_LINEAR)
	
	var manabar_tween = get_tree().create_tween()
	manabar_tween.tween_property(manabar, "value", 0, 5).set_trans(Tween.TRANS_LINEAR)
	
	var mana_damage_bar_tween = get_tree().create_tween()
	mana_damage_bar_tween.tween_property(mana_damage_bar, "value", 0, 5).set_trans(Tween.TRANS_LINEAR)
	
	var mana_bar_fire_tween = get_tree().create_tween()
	mana_bar_fire_tween.tween_property(mana_bar_fire.process_material, "color:a", 0, 5).set_trans(Tween.TRANS_LINEAR)
	
	GlobalCount.surge_count += 1

func get_damage_amount() -> int:
	return damage_amount

func _on_hitbox_body_entered(_body: Node2D) -> void:
	print("sword body entered")

func play_death():
	particles_off_on_death()
	
	velocity = Vector2.ZERO
	state_machine.travel("death")
	var animation_length = animation_player.get_animation("death").length
	await get_tree().create_timer(animation_length).timeout
	
func particles_off_on_death():
	dash_particles.emitting = false
	charge_fire_back_layer.emitting = false
	charge_fire.emitting = false
	gpu_particles_2d.emitting = false

func flash():
	if is_instance_valid(sprite):
		sprite.material.set_shader_parameter("flash_modifier", 1)
		transform_sprite.material.set_shader_parameter("flash_modifier", 1)
		flash_timer.start()

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	health -= 1
	
	if health <= 0:
		death = true
		flash()
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		state_machine.travel("death")
		var animation_length = animation_player.get_animation("death").length
		
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data.first_play_1 == true:
					Global.player_data.deaths_boss_1 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom1":
				if Global.player_data.first_play_2 == true:
					Global.player_data.deaths_boss_2 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom2":
				if Global.player_data.first_play_3 == true:
					Global.player_data.deaths_boss_3 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
		
		await get_tree().create_timer(animation_length).timeout
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				get_tree().reload_current_scene()
			flash_timer.stop()
			
			GlobalCount.death_count += 1
		#GlobalCount.reset_count()

func _on_hurtbox_slash_area_entered(_area: Area2D) -> void:
	health -= 1
	
	if health <= 0:
		death = true
		flash()
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		var animation_length = animation_player.get_animation("death").length
		
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data.first_play_1 == true:
					Global.player_data.deaths_boss_1 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom1":
				if Global.player_data.first_play_2 == true:
					Global.player_data.deaths_boss_2 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom2":
				if Global.player_data.first_play_3 == true:
					Global.player_data.deaths_boss_3 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
		
		await get_tree().create_timer(animation_length).timeout
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				get_tree().reload_current_scene()
			flash_timer.stop()
			
			#GlobalCount.death_count += 1
		
		#GlobalCount.reset_count()
		
func kill_player():
	health -= 1
	
	if health <= 0:
		death = true
		flash()
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		state_machine.travel("death")
		var animation_length = animation_player.get_animation("death").length
		await get_tree().create_timer(animation_length).timeout
		
		match get_tree().get_current_scene().name:
			"BossRoom0":
				if Global.player_data.first_play_1 == true:
					Global.player_data.deaths_boss_1 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom1":
				if Global.player_data.first_play_2 == true:
					Global.player_data.deaths_boss_2 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
			"BossRoom2":
				if Global.player_data.first_play_3 == true:
					Global.player_data.deaths_boss_3 += 1
					Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
		
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				get_tree().reload_current_scene()
			flash_timer.stop()
			
			#GlobalCount.death_count += 1
		

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
	
func restore_dash():
	var dash_meter_tween = get_tree().create_tween()
	dash_meter_tween.tween_property(dash_meter, "value", dash_meter.max_value, 1).set_trans(Tween.TRANS_LINEAR)
	
	dash_cooldown_icon.value = dash_cooldown_icon.max_value
	var dash_icon = get_tree().create_tween()
	dash_icon.tween_property(dash_cooldown_icon, "value", 0, 1).set_trans(Tween.TRANS_LINEAR)
	#if dash_gauge < max_dash_gauge:
		#dash_gauge += 1
			#
	#if dash_gauge == max_dash_gauge:
		#dash_restore_timer.stop()
		
	


func _on_flash_timer_timeout() -> void:
	if is_instance_valid(sprite):
		sprite.material.set_shader_parameter("flash_modifier", 0)
		transform_sprite.material.set_shader_parameter("flash_modifier", 0)



func _on_transform_time_timeout() -> void:
	if is_instance_valid(sprite):
		animation_tree.set("parameters/Attack/TimeScale/scale", 1)
		
		sprite.show()
		transform_sprite.hide()
		damage_amount /= 1.5
		mana = 0
		
		untransform_audio.play()
		gpu_particles_2d.emitting = false
		laser_line_left.emitting = false
		laser_line_right.emitting = false
		ghost_effect_left.emitting = false
		ghostly_effect_right.emitting = false
		
		mana_bar_fire.emitting = false
		transform_fire_bar.emitting = false
		transform_fire_ball.emitting = false

		#print(manabar.get_rect().size.x+3)
		transform_fire_bar.position += Vector2(manabar.get_rect().size.x+3, 0)
		heavy_attack_icon.value = 0
		charge_icon.value = 0
		#print(transform_fire_bar.position)
		
		#transform_fire_bar.position = transform_fire_bar.get_position() + Vector2(manabar.get_rect().size.x, 0)
		#print("end of transformation", mana)
		
		#print("reduced mana by 10 ", mana)
		transformed = false
		transform_time_left.visible = false

# You Piece of Shit decrease mana 
#func decrease_mana():
	#var tween = get_tree().create_tween()
	#tween.tween_property(manabar, "value", 0, 10).set_trans(Tween.TRANS_LINEAR)
	
# Keyed into animationplayer
func transform_sound_play():
	transform_audio.play()
	GlobalCount.camera.apply_shake(10, 40.0)
	
func _on_left_click_permitted():
	can_left_click = true
func _on_right_click_permitted():
	can_right_click = true
	
func beam_circle():
	if is_instance_valid(sprite):
		circle_ref = beam_bar.instantiate()
		add_child(circle_ref)
		
func beam_circle_meteor():
	if is_instance_valid(sprite):
		circle_ref = beam_bar_meteor.instantiate()
		add_child(circle_ref)
		
func transform_icon_disable():
	transform_icon.value = 0
	
func charge_icon_disable():
	charge_icon.value = 100
	
##
#func _on_beam_timer_timeout() -> void:
	#var old_position = position
	#remove_child(circle_ref)
	##boss_2.add_child(circle_ref)
	##circle_ref.global_position = old_global_pos
	#
	##get_tree().get_root().add_child(circle_ref)
	#var boss_room = get_node("../Boss2")
	#boss_room.add_child(circle_ref)
	#print(circle_ref.position)
	#circle_ref.position = old_position
	
	
	
