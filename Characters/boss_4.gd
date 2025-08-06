extends CharacterBody2D
@onready var player = get_parent().find_child("Player")
@onready var boss_room = get_node("..")

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_meter_animation = get_node("../AttackMeterAnimation")
@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var boss_room_animation2 = get_node("../BossRoomAnimationPlayer2")
@onready var plunge_telegraph_animation = get_node("../PlungeTelegraphAnimationPlayer")
@onready var enrage_animation = get_node("../EnrageBackground")
@onready var cutscene_player = get_node("../CutscenePlayer")
@onready var sword_animation_player: AnimationPlayer = $SwordAnimationPlayer
@onready var sword_animation_player_2: AnimationPlayer = $SwordAnimationPlayer2
@onready var sword_fade_animation: AnimationPlayer = $SwordFadeAnimation

@onready var oblivion_ball_animation: AnimationPlayer = $OblivionBallAnimation
@onready var cleave_sword_anim: AnimationPlayer = $CleaveSwordAnim
@onready var slam_attack: AnimatedSprite2D = $JumpSlamAttack/SlamAttack
@onready var slam_attack_2: AnimatedSprite2D = $JumpSlamAttack/SlamAttack2

@onready var sword_marker_in: Marker2D = $SwordInRotate
@onready var sword_marker_out: Marker2D = $SwordOutRotate


@onready var boss_healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar
@onready var healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar/Healthbar

@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var attack_meter: Node2D = $AttackMeter

@onready var flash_timer: Timer = $FlashTimer
@onready var vfx_timer: Timer = $VFXTimer

@onready var boss_killed = get_node("../Portal")
#@onready var boss_death: bool = false

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var canvas_layer: CanvasLayer = $CanvasLayer


@onready var sprite_sword_in: AnimatedSprite2D = $Marker2D/SpriteSwordIn
@onready var sprite_sword_in_2: AnimatedSprite2D = $Marker2D/SpriteSwordIn2
@onready var sprite_sword_out: AnimatedSprite2D = $Marker2D/SpriteSwordOut
@onready var sprite_sword_out_2: AnimatedSprite2D = $Marker2D/SpriteSwordOut2
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop
@onready var darkness_ball: AnimatedSprite2D = $DarknessBall

@onready var full_charge: GPUParticles2D = $FullCharge

@onready var sword_follow_timer: Timer = $SwordFollowTimer
@onready var sword_marker_main: Marker2D = $SwordMarker
@onready var sword_sprite: Sprite2D = $SwordMarker/Marker2D/SwordSprite
@onready var static_sword: Sprite2D = $SwordMarker/StaticSword

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2

@onready var dash_particles: GPUParticles2D = $DashParticles
@onready var dash_trail: Line2D = $DashTrail
@onready var smoke: AnimatedSprite2D = $smoke

@onready var blade_of_ruin_audio: AudioStreamPlayer2D = $BladeOfRuinAudio
@onready var octahit_audio: AudioStreamPlayer2D = $OctahitAudio
@onready var hope_safe_audio: AudioStreamPlayer2D = $HopeSafeAudio
@onready var oblivion_audio: AudioStreamPlayer2D = $OblivionAudio
@onready var constant_fire_audio: AudioStreamPlayer2D = $ConstantFireAudio
@onready var ravage_audio: AudioStreamPlayer2D = $RavageAudio
@onready var premonition_marker_audio: AudioStreamPlayer2D = $PremonitionMarkerAudio
@onready var premonition_symbol_audio: AudioStreamPlayer2D = $PremonitionSymbolAudio
@onready var dash: AudioStreamPlayer2D = $dash
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio


@onready var eruption_audio: AudioStreamPlayer2D = $EruptionAudio


var darkness_balance_vfx = preload("res://Other/darkness_balance_vfx.tscn")
var tether = preload("res://Other/Tether.tscn")
var cleave = preload("res://Other/half_room_cleave.tscn")
var triple_cleave = preload("res://Other/TripleCleave.tscn")
var hit_particle = preload("res://Other/hit_particles.tscn")
var enrage_sword = preload("res://Other/EnrageSword.tscn")
var enrage_attack = preload("res://Other/EnrageWipe.tscn")
#var ravage_audio = preload("res://Other/ravage_audio.tscn")
var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_fade.tscn")
var circle_ref: Node2D

var health_amount = 58000 : set = _set_health #58000
var direction : Vector2
var move_speed = 52.5 #42.5

var gold_count: int = 0
var attack_sequence: int = 0
var debuff_count: int = 0
var oblivion_count: int = 0
var walk_center_count: int = 0
signal gold_clone_aoe

var store_cleave_direction: Vector2
var cleave_direction: Vector2
var pick_direction: int = randi_range(1, 2)
var spawn_sword

var play_ravage

signal boss_died
var boss_death := false:
	set(value):
		boss_death = value
		if boss_death:
			emit_signal("boss_died")

func _ready() -> void:
	smoke.rotation = randf_range(0.0, TAU)
	#gpu_particles_2d.set_use_local_coordinates(true)
	#gpu_particles_2d_2.set_use_local_coordinates(true)
	boss_healthbar.init_health(health_amount)
	darkness_ball.scale = Vector2(0, 0)
	darkness_ball.visible = false
	sword_sprite.self_modulate.a = 0
	static_sword.self_modulate.a = 0
	animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	state_machine.travel("Idle")

func _process(delta: float) -> void:
	if sword_follow_timer.time_left > 0:
		sword_marker_main.rotation = sword_marker_main.global_position.angle_to_point(player.global_position)
		animation_tree.set("parameters/Idle/blend_position", player.global_position - global_position)
		state_machine.travel("Idle")
		
func _physics_process(delta):
	velocity = direction.normalized() * move_speed
	position += velocity * delta
	move_and_slide()
	
	#if input_direction != Vector2.ZERO and !GlobalCount.paused:
		#dash_vector = input_direction*2
		#animation_tree.set("parameters/Walk/blend_position", input_direction)
		#animation_tree.set("parameters/Idle/blend_position", input_direction)
		#animation_tree.set("parameters/Dash/blend_position", input_direction)
		#state_machine.travel("Walk")
		#velocity = input_direction * move_speed
		#if footstep_timer.time_left <= 0 and knockback_time_left <= 0:
			#footsteps.pitch_scale = randi_range(0.8, 1.2)
			#footsteps.play()
			#footstep_timer.start()
		##velocity = Input.get_vector("right", "left", "down", "up").normalized() * move_speed
	#else:
		#state_machine.travel("Idle")
		#velocity = Vector2.ZERO

func _set_health(value):
	health_amount = value
	boss_healthbar.health = health_amount
	
func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("health_amount: ", health_amount)
	print("boss_healthbar: ", healthbar.max_value)

	GlobalCount.healthbar.apply_shake(1, 10.0)
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
		#player.hurtbox_slash_collision.call_deferred("set", "disabled", true)
		#player.hurtbox_collision.call_deferred("set", "disabled", true)
		
		hurtbox.call_deferred("set", "disabled", true)
		
		#boss_room_animation.queue_free()
		#top_bottom_animation_player.queue_free()
		#in_out_animation_player.queue_free()
		animation_player.stop()
		
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")
		remove_state()
		
func remove_state():
	attack_meter.queue_free()
	
func idle_toward_player() -> void:
	var dir: Vector2 = (player.global_position - global_position).normalized()
	
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animation_player.play("idle_right")
		else:
			animation_player.play("idle_left")
	else:
		if dir.y > 0:
			animation_player.play("idle_down")
		else:
			animation_player.play("idle_up")
	
func dash_animation_start():
	dash_particles.texture = sprite.texture
	dash_particles.emitting = true
	dash_trail.visible = true
	
func dash_animation_end():
	dash_particles.emitting = false
	dash_trail.visible = false
		
func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)
	
func spawn_tether():
	var tether_spawn = tether.instantiate()
	tether_spawn.player = player
	tether_spawn.position = Vector2(0, -8)
	add_child(tether_spawn)

func tether_vfx_spawn():
	var spawn_vfx = darkness_balance_vfx.instantiate()
	spawn_vfx.position = Vector2(0, -8)
	add_child(spawn_vfx)

func _on_vfx_timer_timeout() -> void:
	tether_vfx_spawn()

func spawn_cleave():
	var cleave_spawn = cleave.instantiate()
	#if pick_direction == 1:
	cleave_spawn.rotation = sword_marker_main.rotation # + deg_to_rad(90)
	#else:
		#cleave_spawn.rotation = sword_marker_main.rotation + deg_to_rad(-90)
	cleave_spawn.player = player
	#cleave_spawn.direction = pick_direction
	add_child(cleave_spawn)
	
func spawn_triple_cleave():
	var triple = triple_cleave.instantiate()
	triple.player = player
	add_child(triple)
	
func clone_signal():
	emit_signal("gold_clone_aoe")
	
func start_sword_in():
	sprite_sword_in.frame = 0
	sprite_sword_in_2.frame = 0
	sprite_sword_in.play("default")
	sprite_sword_in_2.play("default")

func stop_sword_in():
	sprite_sword_in.stop()
	sprite_sword_in_2.stop()
	sprite_sword_in.frame = 0
	sprite_sword_in_2.frame = 0
	
func start_sword_out():
	sprite_sword_out.frame = 0
	sprite_sword_out_2.frame = 0
	sprite_sword_out.play("default")
	sprite_sword_out_2.play("default")
	
func stop_sword_out():
	sprite_sword_out.stop()
	sprite_sword_out_2.stop()
	sprite_sword_out.frame = 0
	sprite_sword_out_2.frame = 0
	
func darkness_ball_v1():
	darkness_ball.play("default")
	
func darkness_ball_v2():
	darkness_ball.play("new_animation")

func darkness_ball_stop():
	darkness_ball.stop()
	
func slamdown_vfx():
	slam_attack.play("default")
	slam_attack_2.play("default")

#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "swordraise_finish":
		#animation_player.play("idle")
	#elif anim_name == "swordraise_start":
		#animation_player.play("swordraise_charge")
	#elif anim_name == "dash_up" or anim_name == "dash_down" or anim_name == "dash_right" or anim_name == "dash_left":
		#animation_player.play("idle_down")
	#elif anim_name == "cleave_right" or anim_name == "cleave_left" or anim_name == "cleave_up" or anim_name == "cleave_down":
		#animation_player.play("idle_down")
	#elif anim_name == "down_attack":
		#animation_player.play("idle_down")

func play_smoke():
	smoke.play("smoke")
	
func _on_smoke_animation_finished() -> void:
	smoke.rotation = randf_range(0.0, TAU)
	
func enrage_sword_spawn():
	spawn_sword = enrage_sword.instantiate()
	get_parent().add_child(spawn_sword)
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func enrage_sword_free():
	spawn_sword.queue_free()
	
func enrage_sword_flash():
	spawn_sword.sword_flash()
	
func spawn_enrage_attack():
	var spawn_attack = enrage_attack.instantiate()
	get_parent().add_child(spawn_attack)
	
#func spawn_ravage_audio():
	#play_ravage = ravage_audio.instantiate()
	#add_child(play_ravage)
	
func beam_circle():
	circle_ref = beam_bar.instantiate()
	#owner.beam_circle_timer.start()
	circle_ref.position = to_local(player.global_position)
	add_child(circle_ref)
	
