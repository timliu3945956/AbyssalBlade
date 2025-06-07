extends CharacterBody2D

@export var move_speed : float = 85 #85 #42.5
@export var dash_speed: float = 230 #230 # Increase value for faster dash #115
var dash_duration = 0.2
var dash_time_left = 0.0
var can_dash: bool = true
var dash_restore_time: int = 1

const ATTACK_BUFFER_TIME := 0.1
var attack_buffer : float = 0.0

var radius = 5
var controller_aim_direction = Vector2.ZERO
@onready var controller_cursor: Sprite2D = $Smoothing2D/ControllerCursor

# Knockback added code
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.25 #0.15
var knockback_time_left = 0.0
var knockback_damping = 175 #350

enum {
	MOVE,
	DASH,
	ATTACK,
	ATTACK2,
	HEAVYATTACK,
	CHARGE,
	TRANSFORM,
	KNOCKBACK,
	#SHIELD,
	DEATH
}

var swing_start := 0

var attack_step:= 1
var combo_buffer_requested:= false
var combo_window:= 0.15

var state = MOVE

var dash_vector = Vector2.DOWN
var damage_amount : int = 50
var can_attack: bool = true
var attack_busy: bool = false
var attack_queued: bool = false
var transformed: bool = false
var is_transforming: bool = false

var attack_pressed := false

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

@onready var boss_3: CharacterBody2D
@onready var boss_room
@onready var smoothing_2d: Node2D = $Smoothing2D


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
@onready var hurtbox_left: CollisionShape2D = $LeftOppressive/CollisionShape2D
@onready var hurtbox_right: CollisionShape2D = $RightOppressive/CollisionShape2D
@onready var hurtbox_orb: CollisionShape2D = $OrbAbsorbHurtbox/CollisionShape2D
@onready var hurtbox_devour: CollisionShape2D = $DevourOrbHurtbox/CollisionShape2D
@onready var hurtbox_black: CollisionShape2D = $BarrageBlackHurtbox/CollisionShape2D
@onready var hurtbox_white: CollisionShape2D = $BarrageWhiteHurtbox/CollisionShape2D
@onready var player_collision: CollisionShape2D = $CollisionShape2D



@onready var right_oppressive_collision: CollisionShape2D = $RightOppressive/CollisionShape2D
@onready var left_oppressive_collision: CollisionShape2D = $LeftOppressive/CollisionShape2D
@onready var orb_abrsorb_collision: CollisionShape2D = $OrbAbsorbHurtbox/CollisionShape2D
@onready var devour_orb_collision: CollisionShape2D = $DevourOrbHurtbox/CollisionShape2D
@onready var barrage_black_collision: CollisionShape2D = $BarrageBlackHurtbox/CollisionShape2D
@onready var barrage_white_collision: CollisionShape2D = $BarrageWhiteHurtbox/CollisionShape2D


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
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var high_pitch_slice_audio: AudioStreamPlayer2D = $HighPitchSliceAudio


@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles

@onready var orb_soak_audio: AudioStreamPlayer2D = $OrbSoakAudio

@onready var footsteps: AudioStreamPlayer2D = $footsteps
@onready var footstep_timer: Timer = $FootstepTimer

@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var dash_trail: Line2D = $DashTrail

@onready var dash_cooldown: Timer = $Dash_Cooldown
@onready var attack_cooldown: Timer = $Attack_Cooldown
@onready var attack_reset: Timer = $Attack_Reset
@onready var dash_restore_timer: Timer = $Dash_Restore
@onready var dash_meter: ProgressBar = $CanvasLayer/DashMeter

@onready var heavy_attack_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton2/Cooldown
@onready var dash_cooldown_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton3/Cooldown
@onready var charge_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton4/Cooldown
@onready var transform_icon: TextureProgressBar = $CanvasLayer/SkillBar/TextureButton5/Cooldown

@onready var skill_bar: HBoxContainer = $CanvasLayer/SkillBar
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var abyss_mode_chain: Sprite2D = $CanvasLayer/AbyssOverlay/AbyssModeChain


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

#@onready var time: Label = $CanvasLayer/Time
@onready var time: Label = $CanvasLayer/CenterContainer/Time

@onready var full_charge: GPUParticles2D = $FullCharge
@onready var cursor_aim: Marker2D = $Smoothing2D/CursorAim
@onready var boss_2 = get_node("../Boss2")

var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
var beam_bar_meteor = preload("res://Utilities/cast bar/BeamCircle/beam_progress_meteor.tscn")

@onready var vfx_timer: Timer = $VFXTimer
var darkness_balance_vfx = preload("res://Other/darkness_balance_vfx.tscn")
var wind_vfx = preload("res://Other/surge_player_wind.tscn")
var sword_follow = preload("res://Other/sword_follow.tscn")

var circle_ref: Node2D

var can_move: bool= true 
#var health = 100 : set = _set_health
var health = 1
var mana = 0 : set = _set_mana # 20
var attack_count = 0
var dash_gauge = 3
var max_dash_gauge = 3
var input_direction: Vector2 = Vector2.ZERO
var last_direction_input: Vector2
var orb_buff: bool = false
var devour_color: String
var has_gold_clone_buff: bool = false

var oppressive_color: String # = "white" for testing purposes
var color_updated_this_frame = false
#@onready var oppressive_debuff_animation: AnimationPlayer = $Node2D/OppressiveDebuffAnimation
@onready var oppressive_debuff_animation: AnimationPlayer = $OppressiveDebuff/OppressiveDebuffAnimation
@onready var first_gold_vfx: AnimatedSprite2D = $GoldOrbDebuff/FirstGoldVFX
@onready var second_gold_vfx: AnimatedSprite2D = $GoldOrbDebuff/SecondGoldVFX
@onready var gold_orb_vfx_timer: Timer = $GoldOrbDebuff/GoldOrbVFXTimer
@onready var white_debuff_2: AnimatedSprite2D = $OppressiveDebuff/WhiteDebuff2
@onready var black_debuff_2: AnimatedSprite2D = $OppressiveDebuff/BlackDebuff2
@onready var debuff_vfx_timer: Timer = $OppressiveDebuff/DebuffVFXTimer

@onready var testing_area = get_parent().get_node("../Panel2")

var debuffs = preload("res://Other/DebuffBar.tscn")
var debuff_bar

var input_enabled := true


#@onready var fill_style : StyleBoxTexture = manabar.get("theme_override_styles/fill")
#var fill_grad : Gradient = fill_style.gradient
const FULL_LEFT : Color = Color("#3c48fc")
const FULL_RIGHT : Color = Color("#0077ff")
const WHITE_FILL := preload("res://UI/manabar_fill_white_stylebox.tres")
const BLUE_FILL := preload("res://UI/manabar_fill_blue_stylebox.tres")

func _ready():
	# activate when doing tether for boss 5
	if get_tree().get_current_scene().name == "BossRoom0" or get_tree().get_current_scene().name == "BossRoom1" or get_tree().get_current_scene().name == "BossRoom2" or get_tree().get_current_scene().name == "BossRoom3" or get_tree().get_current_scene().name == "BossRoom4" or get_tree().get_current_scene().name == "BossRoom4Final":
		animation_tree.set("parameters/Idle/blend_position", Vector2(0, -1))
		state_machine.start("Idle")
	else:
		animation_tree.set("parameters/Idle/blend_position", Vector2(0, 1))
		state_machine.start("Idle")
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
		
	if get_tree().get_current_scene().name == "BossRoom3":
		boss_3 = get_parent().find_child("Boss3")
		boss_room = get_node("..")
		debuff_vfx_timer.start()
	GlobalEvents.connect("orb_collected", _on_orb_collected)
	GlobalEvents.connect("devour_gold_collected", _on_devour_gold_collected)
	GlobalEvents.connect("devour_red_collected", _on_devour_red_collected)
	devour_color = ""
	"limit_smoothed"
	camera.reset_smoothing()
	if get_tree().get_current_scene().name == "BossRoom4Final":
		mana = GlobalCount.boss_4_final_player_mana
		manabar.value = GlobalCount.boss_4_final_player_mana
		mana_damage_bar.value = GlobalCount.boss_4_final_player_mana
		print("mana: ", mana)
		print("GlobalCount mana :", GlobalCount.boss_4_final_player_mana)
		if mana >= 100:
			manabar.add_theme_stylebox_override("fill", BLUE_FILL)
			charge_icon_disable()
			transform_icon_disable()
			
			mana_bar_fire.process_material.color.a = 1.0
			mana_bar_fire.emitting = true
		else:
			manabar.add_theme_stylebox_override("fill", BLUE_FILL)
				
	manabar.add_theme_stylebox_override("fill", WHITE_FILL)
	manabar.connect("value_changed", _on_mana_changed)
	_on_mana_changed(manabar.value)
	randomize()
	#GlobalCount.abyss_mode = false
	if GlobalCount.abyss_mode:
		dash_restore_time = 5
		abyss_mode_chain.visible = true
	else:
		dash_restore_time = 1
		abyss_mode_chain.visible = false
	
func _on_mana_changed(value: float) -> void:
	if value >= manabar.max_value:
		manabar.add_theme_stylebox_override("fill", BLUE_FILL)
	elif value <= 0:
		manabar.add_theme_stylebox_override("fill", WHITE_FILL)
		
func play_with_random_pitch(player : AudioStreamPlayer2D, min_pitch: float = 0.92, max_pitch: float = 1.12) -> void:
	player.pitch_scale = randf_range(min_pitch, max_pitch)
	player.play()
	
func _input(event):
	if event.is_action_pressed("attack") and !GlobalCount.paused:
		attack_buffer = ATTACK_BUFFER_TIME
	else:
		attack_buffer = 0.0
		
	if event is InputEventJoypadButton:
		print("BUTTON  :", event.device, " id:", event.button_index, " pressed:", event.pressed)
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.05:           # ignore tiny jitters
			print("AXIS    :", event.device, " axis:", event.axis, " value:", event.axis_value)
	
func _process(delta):
	attack_buffer = max(attack_buffer - delta, 0.0)
	var elapsed_time = GlobalCount.elapsed_time
	
	var minutes = int(elapsed_time) / 60 # Total minutes
	var seconds = int(elapsed_time) % 60 # Remaining seconds
	var milliseconds = int((elapsed_time - int(elapsed_time)) * 100)
	var time_string = "%2d:%02d:%02d" % [minutes, seconds, milliseconds]
	if GlobalCount.timer_active:
		time.visible = true
		time.text = time_string
	
	var hold_attack = InputManager.GetActionPressed("attack") #Input.is_action_pressed("attack")
	var want_attack = hold_attack or attack_buffer > 0.0
	if state == MOVE and want_attack and !GlobalCount.paused and attack_cooldown.is_stopped():
		_start_attack()
		attack_buffer = 0.0
		
func _physics_process(delta):
	if !input_enabled:
		return
	input_direction = InputManager.GetMovementVector()
	input_direction = input_direction.normalized()
	#if InputManager.controllerManager.activeController == -1:
		#input_direction = Vector2(
			#Input.get_action_strength("right") - Input.get_action_strength("left"),
			#Input.get_action_strength("down") - Input.get_action_strength("up")
		#)
		#input_direction = input_direction.normalized()
	##else:
	#if InputManager.controllerManager.activeController != -1:
		#input_direction = Input.get_vector("left", "right", "up", "down")
		#input_direction = input_direction.normalized()
		#if input_direction.length() > 0:
			#input_direction = input_direction.normalized()
	 #Reads right analog stick input
	var right_stick_input = Vector2(
		Input.get_joy_axis(0, 2),
		Input.get_joy_axis(0, 3)
	)
	if InputManager.activeInputSource == 1:
		controller_aim_direction = right_stick_input
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if controller_aim_direction.length() >= 0.2:
			controller_aim_direction = right_stick_input.normalized()
			
			last_direction_input = controller_aim_direction
			cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position)
		else:
			controller_aim_direction = last_direction_input
			cursor_aim.rotation = global_position.angle_to_point(controller_aim_direction + global_position)
	else:
		controller_aim_direction = (get_global_mouse_position() - global_position).normalized()
		cursor_aim.rotation = cursor_aim.global_position.angle_to_point(get_global_mouse_position())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if InputManager.GetActionJustPressed("transform") and mana >= 100 and !transformed and !GlobalCount.paused and !GlobalCount.abyss_mode:
		buffered_transform_input = true
	
	######## Knockback added code
	if state == KNOCKBACK:
		if knockback_time_left > 0:
			knockback_time_left -= delta
			if death == false:
				velocity = knockback_velocity
			else:
				velocity = Vector2.ZERO
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
			attack_busy = false
		else:
			move_speed = 85
			if is_transforming:
				state = TRANSFORM
				transform_timer()
			else:
				state = MOVE
	elif !death:
			match state:
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
					
	else:
		state = DEATH
		play_death()
		
	if state != KNOCKBACK:
		process_input_buffer()
		
	if dash_meter.value >= 100:
		can_dash = true
		
func _set_mana(value):
	mana = value
	manabar.mana = mana
		
# Knockback function for pushing player away from center
func apply_knockback(source_position: Vector2, force: float):
	if death == false:
		var knockback_direction = (global_position - source_position).normalized()
		knockback_velocity = knockback_direction * force
		knockback_time_left = knockback_duration
		state = KNOCKBACK
	
#func _input(event):
	#if event.is_action_pressed("attack"): #and attack_cooldown.is_stopped()
		#attack_pressed = true

func move_state(delta):
	if input_direction != Vector2.ZERO and !GlobalCount.paused:
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
		if InputManager.GetActionJustPressed("dash") and can_dash and !GlobalCount.paused:
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
		
		#elif attack_pressed and !attack_busy and attack_cooldown.is_stopped() and !GlobalCount.paused:
			#_start_attack()
		#attack_pressed = false
		
		#elif Input.is_action_pressed("attack") and not attack_busy and !GlobalCount.paused:
			#if Input.is_action_pressed("heavyattack"):
				#pass
			#else:
				#_start_attack()
			#animation_tree.set("parameters/Attack/Attack/blend_position", controller_aim_direction)
			#animation_tree.set("parameters/Attack2/Attack2/blend_position", controller_aim_direction)
			#animation_tree.set("parameters/Idle/blend_position", controller_aim_direction)
			#if attack_step == 1:
				#attack_step = 2
			#else:
				#attack_step = 1
			#attack_reset.stop()
			#attack_reset.start()
			#state = ATTACK
			#swing.play()
			#can_attack = false
			#if !transformed:
				##can_attack = false
				##attack_cooldown.start()
				#pass
			#else:
				#attack_cooldown.stop()
				#
				#count_dash_gauge()
			#return
			#GlobalCount.slash_count += 1
			
		if InputManager.GetActionPressed("heavyattack") and !transformed and !GlobalCount.paused:
			animation_tree.set("parameters/HeavyAttack/blend_position", controller_aim_direction)
			animation_tree.set("parameters/Idle/blend_position", controller_aim_direction)
			state = HEAVYATTACK
			move_speed = move_speed / 2
			#dash_gauge -= 1
			count_dash_gauge()
			
		if InputManager.GetActionPressed("charge") and !transformed and mana < 100 and GlobalCount.can_charge and !GlobalCount.paused and !GlobalCount.abyss_mode:
			animation_tree.set("parameters/Charge/blend_position", animation_tree.get("parameters/Idle/blend_position"))
			state = CHARGE
			charge.play()
		
		if InputManager.GetActionJustPressed("transform") and mana >= 100 and !transformed and !GlobalCount.paused and !GlobalCount.abyss_mode:
			animation_tree.set("parameters/Attack/TimeScale/scale", 2) #1.5
			animation_tree.set("parameters/Attack2/TimeScale/scale", 2) #1.5
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
			velocity = Vector2.ZERO * delta
		dash_particles.emitting = false
		dash_trail.visible = false
		state = MOVE
		
func count_dash_gauge():
	for i in range(max_dash_gauge):
		particles[i].emitting = i < dash_gauge

func _start_attack() -> void:
	swing_start = Time.get_ticks_msec()
	#attack_queued = false
	#can_attack = false
	if transformed:
		attack_cooldown.start(0.125)
	else:
		attack_cooldown.start(0.25)
	attack_busy = true
	can_attack = false
	
	
	if attack_step == 1:
		attack_step = 2
		state_machine.travel("Attack")
	else:
		attack_step = 1
		state_machine.travel("Attack2")
	
	animation_tree.set("parameters/Attack/Attack/blend_position", controller_aim_direction)
	animation_tree.set("parameters/Attack2/Attack2/blend_position", controller_aim_direction)
	animation_tree.set("parameters/Idle/blend_position", controller_aim_direction)
	#swing.play()
	play_with_random_pitch(swing, 0.9, 1.15)
	
	if InputManager.GetActionJustPressed("dash") and can_dash and dash_meter.value >= 100 and !GlobalCount.paused:
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
		attack_busy = false
		#attack_queued = true
		#can_attack = false
		state_machine.travel("Dash")
		return
	
	state = ATTACK

func attack_state(delta):
	move_speed = 85
	if InputManager.GetActionJustPressed("dash") and can_dash and dash_meter.value >= 100 and !GlobalCount.paused:
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
		attack_busy = false
		#attack_queued = true
		#can_attack = false
		state_machine.travel("Dash")
		
	elif InputManager.GetActionJustPressed("transform") and mana >= 100 and !transformed and !GlobalCount.paused and !GlobalCount.abyss_mode:
			animation_tree.set("parameters/Attack/TimeScale/scale", 2) #1.5
			animation_tree.set("parameters/Attack2/TimeScale/scale", 2) #1.5
			state = TRANSFORM
			attack_busy = false
	else:
		if knockback_time_left > 0:
			state = KNOCKBACK
		else:
			if !transformed:
				input_direction = input_direction.normalized()
				velocity = input_direction * move_speed
			else:
				velocity = Vector2.ZERO #commented out for move while attacking test
	move()

func heavy_attack_state(delta):
	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed
	move_speed = max(move_speed - (40.48 * delta), 0) #40.48 #20.24 * delta

	if InputManager.GetActionJustPressed("dash") and can_dash and !GlobalCount.paused:
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
	elif InputManager.GetActionJustPressed("transform") and mana >= 100 and !transformed and !GlobalCount.paused and !GlobalCount.abyss_mode:
			animation_tree.set("parameters/Attack/TimeScale/scale", 2) #1.5
			animation_tree.set("parameters/Attack2/TimeScale/scale", 2) #1.5
			state = TRANSFORM
	else:
		state_machine.travel("HeavyAttack")
	move()
	attack_busy = false
	
func heavy_attack_hit():
	#swing.play()
	play_with_random_pitch(swing, 0.9, 1.15)
	#GlobalCount.camera.apply_shake(3.0, 20.0)
func heavy_attack_finish():
	move_speed = 85
	
func charge_state(delta):
	print(delta)
	velocity = Vector2.ZERO
	state_machine.travel("Charge")
	charge_fire_back_layer.emitting = true
	charge_fire.emitting = true
	#if GlobalCount.can_pause == true:
		#mana += 100
		#full_charge.emitting = true
		#mana_bar_fire.process_material.color.a = 1.0
		#mana_bar_fire.emitting = true
		#await get_tree().create_timer(0.2).timeout
		#state = MOVE
	if mana < 100:
		mana += (delta * 10)
		if mana >= 100:
			surge_ready.play()
			mana_bar_fire.process_material.color.a = 1.0
			mana_bar_fire.emitting = true
	elif death:
		mana += 0
		charge_fire_back_layer.emitting = false
		charge_fire.emitting = false
		state = MOVE
	#else:
	if mana >= 100:
		charge_icon.value = 100 #disable charge icon UI
		transform_icon.value = 0
		charge_fire_back_layer.emitting = false
		charge_fire.emitting = false
		state = MOVE
		
	if InputManager.GetActionJustReleased("charge") and !GlobalCount.paused and !GlobalCount.abyss_mode:
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
		if mana >= 100 and !transformed:
			if state in transform_allowed_states:
				animation_tree.set("parameters/Attack/TimeScale/scale", 2) #1.5
				animation_tree.set("parameters/Attack2/TimeScale/scale", 2) #1.5
				state = TRANSFORM
				buffered_transform_input = false
				attack_busy = false
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
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	#print(anim_name)
	if anim_name.begins_with("attack"):
		var dur = Time.get_ticks_msec() - swing_start
		print("Swing length (ms): ", dur)
		attack_busy = false
		if InputManager.GetActionJustPressed("dash") and can_dash and !GlobalCount.paused:
			state = DASH
			return
			
		state = MOVE
		return
		#if Input.is_action_pressed("attack") and attack_cooldown.is_stopped() and !GlobalCount.paused:
			#_start_attack()
			#return
			#
		#
		#attack_busy = false
		#state = MOVE
		#return
	if anim_name.begins_with("heavy"):
		move_speed = 85
		state = MOVE
		return
		
	#if anim_name.begins_with("charge"):
		#if InputManager.GetActionJustPressed("dash") and can_dash and !GlobalCount.paused:
			#state = DASH
			#return
		
	if anim_name == "transform":
		transform_timer()
	
	#if Input.is_action_just_pressed("dash") and can_dash and !GlobalCount.paused:
			#state = DASH
			#return
		
	state = MOVE
	
func transform_move_fire_bar():
	transform_fire_bar.position = Vector2(manabar.position.x + 144.945, manabar.position.y + 2)

func transform_timer():
	is_transforming = false
	sprite.hide()
	transform_sprite.show()
	transform_time.start()
	damage_amount *= 1.5 #1.5
	
	laser_line_left.emitting = true
	laser_line_right.emitting = true
	ghost_effect_left.emitting = true
	ghostly_effect_right.emitting = true
	
	print(transform_fire_bar.position)
	#transform_fire_bar.position = Vector2(manabar.position.x + 144.945, manabar.position.y + 2)
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
	hurtbox_slash.disabled = true
	hurtbox.disabled = true
	hurtbox_slash_collision.disabled = true
	hurtbox_collision.disabled = true
	right_oppressive_collision.disabled = true
	left_oppressive_collision.disabled = true
	orb_abrsorb_collision.disabled = true
	devour_orb_collision.disabled = true
	barrage_black_collision.disabled = true
	barrage_white_collision.disabled = true
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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	health -= 1
	print("player die in this: ", area)
	if health <= 0:
		death = true
		death_audio.play()
		#GlobalCount.slow_down_game()
		flash()
		
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		state_machine.travel("death")
		var animation_length = animation_player.get_animation("death").length
		
		await get_tree().create_timer(animation_length).timeout
		GlobalCount.death_count += 1
		Global.player_data_slots[Global.current_slot_index].deaths += 1
		if Global.player_data_slots[Global.current_slot_index].deaths >= 1:
			var achievement = Steam.getAchievement("Die1")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die1")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 100:
			var achievement = Steam.getAchievement("Die100")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die100")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 200:
			var achievement = Steam.getAchievement("Die200")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die200")
				Steam.storeStats()
		Global.save_data(Global.current_slot_index)
		
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				if get_tree().get_current_scene().name == "BossRoom4Final":
					get_tree().change_scene_to_file("res://Levels/BossRoom4.tscn")
				else:
					get_tree().reload_current_scene()
			flash_timer.stop()
			
			
		#GlobalCount.reset_count()

func _on_hurtbox_slash_area_entered(area: Area2D) -> void:
	health -= 1
	print("player die in this: ", area)
	if health <= 0:
		death = true
		death_audio.play()
		#GlobalCount.slow_down_game()
		flash()
		
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		var animation_length = animation_player.get_animation("death").length
		
		await get_tree().create_timer(animation_length).timeout
		GlobalCount.death_count += 1
		Global.player_data_slots[Global.current_slot_index].deaths += 1
		if Global.player_data_slots[Global.current_slot_index].deaths >= 1:
			var achievement = Steam.getAchievement("Die1")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die1")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 100:
			var achievement = Steam.getAchievement("Die100")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die100")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 200:
			var achievement = Steam.getAchievement("Die200")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die200")
				Steam.storeStats()
		Global.save_data(Global.current_slot_index)
		
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				if get_tree().get_current_scene().name == "BossRoom4Final":
					get_tree().change_scene_to_file("res://Levels/BossRoom4.tscn")
				else:
					get_tree().reload_current_scene()
			flash_timer.stop()
			
			
		#GlobalCount.reset_count()
		
func kill_player():
	health -= 1
	print("player dieing to kill function call")
	if health <= 0:
		death = true
		death_audio.play()
		#GlobalCount.slow_down_game()
		flash()
		
		HitStopManager.hit_stop_short()
		GlobalCount.camera.apply_shake(5, 20.0)
		
		state_machine.travel("death")
		var animation_length = animation_player.get_animation("death").length
		
		await get_tree().create_timer(animation_length).timeout
		GlobalCount.death_count += 1
		Global.player_data_slots[Global.current_slot_index].deaths += 1
		if Global.player_data_slots[Global.current_slot_index].deaths >= 1:
			var achievement = Steam.getAchievement("Die1")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die1")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 100:
			var achievement = Steam.getAchievement("Die100")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die100")
				Steam.storeStats()
		if Global.player_data_slots[Global.current_slot_index].deaths >= 200:
			var achievement = Steam.getAchievement("Die200")
			if achievement.ret && !achievement.achieved:
				Steam.setAchievement("Die200")
				Steam.storeStats()
		Global.save_data(Global.current_slot_index)
		
		if is_instance_valid(sprite):
			sprite.queue_free()
			transform_sprite.queue_free()
			TransitionScreen.transition_dead()
			await TransitionScreen.on_transition_finished
			if get_tree():
				if get_tree().get_current_scene().name == "BossRoom4Final":
					get_tree().change_scene_to_file("res://Levels/BossRoom4.tscn")
				else:
					get_tree().reload_current_scene()
			flash_timer.stop()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
	var want_again = InputManager.GetActionPressed("attack") or attack_buffer > 0.0
	if want_again and state == MOVE and !GlobalCount.paused:
		_start_attack()
		attack_buffer = 0.0
	
func _on_attack_reset_timeout() -> void:
	attack_step = 1
	
func restore_dash():
	print(dash_restore_time)
	var dash_meter_tween = get_tree().create_tween()
	dash_meter_tween.tween_property(dash_meter, "value", dash_meter.max_value, dash_restore_time).set_trans(Tween.TRANS_LINEAR) #1 second
	
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
		animation_tree.set("parameters/Attack2/TimeScale/scale", 1)
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
		smoothing_2d.add_child(circle_ref)
		
func beam_circle_quake():
	if is_instance_valid(sprite):
		circle_ref = beam_bar.instantiate()
		#circle_ref.position += Vector2(0, -5)
		smoothing_2d.add_child(circle_ref)
		
func beam_circle_meteor():
	if is_instance_valid(sprite):
		circle_ref = beam_bar_meteor.instantiate()
		circle_ref.position += Vector2(0, 10)
		smoothing_2d.add_child(circle_ref)
		
func transform_icon_disable():
	transform_icon.value = 0
	
func charge_icon_disable():
	charge_icon.value = 100
	
func surge_wind_up_vfx():
	if transformed:
		var surge_wind = wind_vfx.instantiate()
		surge_wind.attack_type = "up"
		surge_wind.player = self
		get_parent().add_child(surge_wind)

func surge_wind_down_vfx():
	if transformed:
		var surge_wind = wind_vfx.instantiate()
		surge_wind.attack_type = "down"
		surge_wind.player = self
		get_parent().add_child(surge_wind)
		
func surge_wind_left_vfx():
	if transformed:
		var surge_wind = wind_vfx.instantiate()
		surge_wind.attack_type = "left"
		surge_wind.player = self
		get_parent().add_child(surge_wind)

func surge_wind_right_vfx():
	if transformed:
		var surge_wind = wind_vfx.instantiate()
		surge_wind.attack_type = "right"
		surge_wind.player = self
		get_parent().add_child(surge_wind)
		
func on_boss_defeated() -> void:
	input_enabled = false
	velocity = Vector2.ZERO
	#move_and_slide()
	##animation_tree.active = false
	#await get_tree().physics_frame
	#set_physics_process(false)
	#set_process(false)

# ----------------------------------------------------------// FOR BOSS3 MECHANICS
func _on_left_oppressive_area_entered(area: Area2D) -> void:
	boss_3.oppressive_debuff_count += 1
	
	if boss_3.left_color == "white":
		if oppressive_color == "white":
			kill_player()
			print("player_killed")
		elif oppressive_color == "black":
			oppressive_debuff_animation.play("black_transition_white")
			print("blk transition into white")
		else:
			oppressive_debuff_animation.play("white_start")
	elif boss_3.left_color == "black":
		if oppressive_color == "black":
			kill_player()
			print("player_killed")
		elif oppressive_color == "white":
			oppressive_debuff_animation.play("white_transition_black")
		else:
			oppressive_debuff_animation.play("black_start")
	oppressive_color = boss_3.left_color

func _on_right_oppressive_area_entered(area: Area2D) -> void:
	boss_3.oppressive_debuff_count += 1
	print("getting hit by right side: ", boss_3.right_color)
	
	if boss_3.right_color == "white":
		if oppressive_color == "white":
			kill_player()
		elif oppressive_color == "black":
			oppressive_debuff_animation.play("black_transition_white")
		else:
			oppressive_debuff_animation.play("white_start")
	if boss_3.right_color == "black":
		if oppressive_color == "black":
			kill_player()
		elif oppressive_color == "white":
			oppressive_debuff_animation.play("white_transition_black")
		else:
			oppressive_debuff_animation.play("black_start")
	oppressive_color = boss_3.right_color

func _on_orb_collected():
	orb_buff_vfx()
	get_tree().create_timer(0.2).timeout
	orb_buff = true
	
	
func orb_buff_vfx():
	gold_orb_vfx_timer.start()
	first_gold_vfx.modulate.a = 1
	second_gold_vfx.modulate.a = 1
	#var first_vfx = get_tree().create_tween()
	#first_vfx.tween_property(first_gold_vfx, "modulate:a", 1, 0.3)
	#var second_vfx = get_tree().create_tween()
	#second_vfx.tween_property(second_gold_vfx, "modulate:a", 1, 0.3)
	first_gold_vfx.play("default")

func orb_buff_vfx_off():
	var first_vfx = get_tree().create_tween()
	first_vfx.tween_property(first_gold_vfx, "modulate:a", 0, 0.2)
	var second_vfx = get_tree().create_tween()
	second_vfx.tween_property(second_gold_vfx, "modulate:a", 0, 0.2)
	
func _on_gold_orb_vfx_timer_timeout() -> void:
	second_gold_vfx.play("default")
	
func _on_devour_gold_collected():
	if devour_color == "gold":
		devour_color == "gold"
	elif devour_color == "red":
		devour_color = "gold"
	else:
		devour_color = "gold"
	orb_buff_vfx()
	
	
func _on_devour_red_collected():
	if devour_color == "red":
		kill_player()
		sac_aoe_1.play("default")
		sac_aoe_2.play("default")
		aoe_particles.emitting = true
	elif devour_color == "gold":
		devour_color = "red"
	else:
		kill_player()
		sac_aoe_1.play("default")
		sac_aoe_2.play("default")
		aoe_particles.emitting = true
	orb_buff_vfx_off()

func _on_barrage_black_hurtbox_area_entered(area: Area2D) -> void:
	print("going into this function instantly?")
	if oppressive_color == "white":
		oppressive_debuff_animation.play("white_transition_black")
	else:
		kill_player()
	oppressive_color = "black"

func _on_barrage_white_hurtbox_area_entered(area: Area2D) -> void:
	print("going into this function instantly?")
	if oppressive_color == "black":
		oppressive_debuff_animation.play("black_transition_white")
	else:
		kill_player()
	oppressive_color = "white"

func _on_debuff_vfx_timer_timeout() -> void:
	white_debuff_2.play("default")
	black_debuff_2.play("default")
	
# ----------------------------------------------------------// FOR BOSS4 MECHANICS (Boss 5)
func tether_vfx_spawn():
	var spawn_vfx = darkness_balance_vfx.instantiate()
	spawn_vfx.position = Vector2(0, -8)
	smoothing_2d.add_child(spawn_vfx)

func _on_vfx_timer_timeout() -> void:
	tether_vfx_spawn()

func spawn_debuffs():
	debuff_bar = debuffs.instantiate()
	debuff_bar.DEBUFF_TIMES = [7, 11, 15, 19]
	smoothing_2d.add_child(debuff_bar)

func spawn_debuffs_final():
	debuff_bar = debuffs.instantiate()
	debuff_bar.DEBUFF_TIMES = [12, 18, 24, 30]
	smoothing_2d.add_child(debuff_bar)

func spawn_sword():
	var sword = sword_follow.instantiate()
	smoothing_2d.add_child(sword)


func _on_orb_absorb_hurtbox_area_entered(area: Area2D) -> void:
	orb_buff_vfx()
	orb_soak_audio.play()
	get_tree().create_timer(0.2).timeout
	orb_buff = true
