extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_room = get_node("..")

@onready var collision: CollisionShape2D = $SlashHitBox/CollisionShape2D
#@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D


@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D


@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tether_animation_player: AnimationPlayer = $TetherAnimationPlayer

@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var boss_room_animation_2 = get_node("../BossRoomAnimationPlayer2")
@onready var boss_charge_animation = get_node("../BossChargeAnimationPlayer")
@onready var flash_room_animation = get_node("../FlashArenaAnimationPlayer")
@onready var boss_clone_animation = get_node("../BossCloneAnimationPlayer")
@onready var boss_clone_animation_2 = get_node("../BossCloneAnimationPlayer2")
@onready var chromatic_abberation_animation = get_node("../ChromaticAbberationPlayer")
@onready var enrage_background = get_node("../EnrageBackground")
@onready var circle_animation = get_node("../CircleAnimationPlayer")
@onready var boss_death_anim = get_node("../BossDeathAnimation")

@onready var top_bottom_attack: AnimatedSprite2D = get_node("../ForegroundArena/VHRotation/TopBottomAttack/TopBottomAttack")
@onready var top_bottom_attack_2: AnimatedSprite2D = get_node("../ForegroundArena/VHRotation/TopBottomAttack/TopBottomAttack2")
@onready var nsew_attack: AnimatedSprite2D = get_node("../ForegroundArena/NSEWRotation/NSEWAttack/NSEWAttack")
@onready var nsew_attack_2: AnimatedSprite2D = get_node("../ForegroundArena/NSEWRotation/NSEWAttack/NSEWAttack2")
#@onready var slam_attack: AnimatedSprite2D = get_node("../ForegroundArena/Marker2D/JumpSlamAttack/SlamAttack")
#@onready var slam_attack_2: AnimatedSprite2D = get_node("../ForegroundArena/Marker2D/JumpSlamAttack/SlamAttack2")
#@onready var jump_slam_attack: Sprite2D = get_node("../ForegroundArena/Marker2D/JumpSlamAttack")
@onready var jump_slam_attack: Sprite2D = $JumpSlamAttack
@onready var slam_attack: AnimatedSprite2D = $JumpSlamAttack/SlamAttack
@onready var slam_attack_2: AnimatedSprite2D = $JumpSlamAttack/SlamAttack2
@onready var slam_particles: GPUParticles2D = $JumpSlamAttack/SlamParticles

@onready var spit_attack_white: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttack/SpitAttackWhite
@onready var spit_attack_red: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttack/SpitAttackRed
@onready var spit_attack_white_enrage: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttackEnraged/SpitAttackWhiteEnrage
@onready var spit_attack_red_enrage: AnimatedSprite2D = $SpitAim/HitboxSpit/SpitAttackEnraged/SpitAttackRedEnrage
@onready var spit_attack_follow_timer: Timer = $SpitAttackFollowTimer

@onready var idle: Node2D = $FiniteStateMachine/Idle
@onready var follow: Node2D = $FiniteStateMachine/Follow
@onready var spit_attack: Node2D = $FiniteStateMachine/SpitAttack
@onready var move_to_center: Node2D = $FiniteStateMachine/MoveToCenter
@onready var cleave_charge_1: Node2D = $FiniteStateMachine/CleaveCharge1
@onready var walk_left: Node2D = $FiniteStateMachine/WalkLeft
@onready var tether_left: Node2D = $FiniteStateMachine/TetherLeft
@onready var cleave_charge_2: Node2D = $FiniteStateMachine/CleaveCharge2
@onready var walk_right: Node2D = $FiniteStateMachine/WalkRight
@onready var tether_right: Node2D = $FiniteStateMachine/TetherRight
@onready var dodge_shadow_clone: Node2D = $FiniteStateMachine/DodgeShadowClone
@onready var dodge_shadow_clone_combo: Node2D = $FiniteStateMachine/DodgeShadowCloneCombo
@onready var cleave_1: Node2D = $FiniteStateMachine/Cleave1
@onready var shadow_clone: Node2D = $FiniteStateMachine/ShadowClone
@onready var shadow_clone_combo: Node2D = $FiniteStateMachine/ShadowCloneCombo
@onready var cleave_2: Node2D = $FiniteStateMachine/Cleave2
@onready var enrage: Node2D = $FiniteStateMachine/Enrage
@onready var mini_enrage: Node2D = $FiniteStateMachine/MiniEnrage
@onready var cleave_attacks: Node2D = $FiniteStateMachine/CleaveAttacks
@onready var canvas_layer: CanvasLayer = $CanvasLayer


@onready var boss_jump_timer: Timer = $BossJumpTimer

@onready var boss_killed = get_node("../Portal")
@onready var boss_death: bool = false

@onready var enrage_fire: GPUParticles2D = $EnrageFire
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop

# flash particles
@onready var sprite = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer
@onready var marker_2d: Marker2D = $Marker2D

@onready var spit_aim: Marker2D = $SpitAim

@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow

@onready var jump_wind: AnimatedSprite2D = $JumpWind

@onready var spit_audio: AudioStreamPlayer2D = $spit_audio
@onready var jump_audio: AudioStreamPlayer2D = $jump_audio
@onready var land_audio: AudioStreamPlayer2D = $land_audio
@onready var phase_2_audio: AudioStreamPlayer2D = $phase_2_audio

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

@onready var boss_healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar
@onready var boss_death_animation: AnimationPlayer = $"../BossDeathAnimation"


var hit_particle = preload("res://Other/hit_particles.tscn")

var direction : Vector2
var move_speed = 60 #120
var spit_count: int = 0

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 40000 : set = _set_health #39000
var center_of_screen = get_viewport_rect().size / 2

var timeline: int = 0
var pick_top_bottom = randi_range(1, 2)
var pick_ns_ew = randi_range(1, 2)
var pick_cleave = randi_range(1, 2)
var spit_enrage: bool = false #false

var _last_t : int

func _ready():
	randomize()
	set_physics_process(false)
	boss_healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	GlobalCount.can_charge = false
	spit_enrage = false
	enrage_fire_pop.emitting = false
	#boss_death_animation.play_back_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	_last_t = Time.get_ticks_usec()

func _process(_delta):
	if spit_attack_follow_timer.time_left > 0:
		spit_aim.rotation = spit_aim.global_position.angle_to_point(player.global_position)

	if boss_jump_timer.time_left > 0:
		#enrage_fire.global_position = global_position + Vector2(0, -23)
		position = player.position
		jump_slam_attack.global_position = player.global_position
		
	var now := Time.get_ticks_usec()
	var dt := float(now - _last_t) * 1e-6
	_last_t = now
	boss_death_anim.advance(dt)
	
func _physics_process(delta):
	velocity = direction.normalized() * move_speed
	position += velocity * delta
	move_and_slide()

func _set_health(value):
	health_amount = value
	boss_healthbar.health = health_amount
	
func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	GlobalCount.healthbar.apply_shake(1, 10.0)
	print(health_amount)
	if area.name == "HitBox":
		health_amount -= player.damage_amount
		GlobalCount.dps_count += player.damage_amount
		flash()
		
		if player.transformed:
			spawn_attack_vfx("surge")
		else:
			spawn_attack_vfx("normal")
		
		player.attack_count += 1
		if player.dash_gauge >= 3 and not player.transformed:
			player.attack_count = 0
		if player.attack_count >= 3 and not player.transformed:
			player.dash_gauge += 1
			player.count_dash_gauge()
			player.attack_count = 0
		
		if player.swing.playing:
			player.swing.stop()
		if player.transformed:
			player.play_with_random_pitch(player.abyssal_surge_hit, 0.9, 1.15)
			#player.abyssal_surge_hit.play()
		else:
			player.play_with_random_pitch(player.hit, 0.9, 1.15)
			#player.hit.play()
			
		if !GlobalCount.abyss_mode:
			if player.mana < 100:
				player.mana += 3
				if player.mana >= 100:
					player.charge_icon_disable()
					player.transform_icon_disable()
					player.surge_ready.play()
					
					player.mana_bar_fire.process_material.color.a = 1.0
					player.mana_bar_fire.emitting = true
	elif area.name == "HeavyHitBox":
		health_amount -= (player.damage_amount * 8) #4
		GlobalCount.dps_count += (player.damage_amount * 8) #4
		flash()
		
		spawn_attack_vfx("heavy")
		
		if player.swing.playing:
			player.swing.stop()
		
		player.play_with_random_pitch(player.heavy_hit, 0.9, 1.15)
		#player.heavy_hit.play()
		
		if !GlobalCount.abyss_mode:
			if player.mana < 100:
				player.mana += 20 #4
				if player.mana >= 100:
					player.charge_icon_disable()
					player.transform_icon_disable()
					player.surge_ready.play()
					
					player.mana_bar_fire.process_material.color.a = 1.0
					player.mana_bar_fire.emitting = true
		
	if health_amount <= 0:
		sprite.start_shake(1.8, 0.2)
		player.high_pitch_slice_audio.play()
		boss_death_anim.play("death")
		#GlobalCount.timer_active = false
		HitStopManager.hit_stop_boss_death()
		
		hurtbox.call_deferred("set", "disabled", true)
		
		animation_player.stop()
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")
		remove_state()

func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)
		
func remove_state():
	idle.queue_free()
	follow.queue_free()
	spit_attack.queue_free()
	move_to_center.queue_free()
	cleave_charge_1.queue_free()
	walk_left.queue_free()
	tether_left.queue_free()
	cleave_charge_2.queue_free()
	walk_right.queue_free()
	tether_right.queue_free()
	dodge_shadow_clone.queue_free()
	dodge_shadow_clone_combo.queue_free()
	cleave_1.queue_free()
	shadow_clone.queue_free()
	shadow_clone_combo.queue_free()
	cleave_2.queue_free()
	enrage.queue_free()
	mini_enrage.queue_free()
	cleave_attacks.queue_free()
	canvas_layer.queue_free()
	attack_meter.queue_free()
	boss_room_animation.queue_free()
	
func spit_attack_visual():
	spit_attack_white.play("default")
	spit_attack_red.play("default")

func spit_attack_enrage_visual():
	spit_attack_white_enrage.play("default")
	spit_attack_red_enrage.play("default")
	
func slam_attack_animation():
	slam_attack.play("new_animation")
	slam_attack_2.play("default")
	slam_particles.emitting = true
	
func jump_wind_vfx():
	jump_wind.play("default")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#print(anim_name)
	if anim_name == "buff_attack":
		animation_player.play("idle_right")

func spit_sound():
	spit_audio.play()
	
func jump_sound():
	jump_audio.play()

func land_sound():
	land_audio.play()

func phase_2_sound():
	phase_2_audio.play()
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func camera_shake_phase_2():
	GlobalCount.camera.apply_shake(5, 25.0)
