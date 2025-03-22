extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_ranged = get_parent().find_child("Boss2Ranged")
@onready var boss_melee = get_parent().find_child("Boss2Melee")
@onready var boss_room = get_node("..")
#@onready var collision: CollisionShape2D = $SlashHitBox/CollisionShape2D
#@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D

@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var telegraph_player: AnimationPlayer = $TelegraphPlayer

#@onready var tether_animation_player: AnimationPlayer = $TetherAnimationPlayer
@onready var healthbar_fade_animation_player = get_node("../HealthbarFadeAnimationPlayer")

#@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
#@onready var boss_room_animation_2 = get_node("../BossRoomAnimationPlayer2")
@onready var attack_meter_animation = get_node("../AttackMeterAnimationPlayer")

@onready var triangle_animation_long = get_node("../TriangleTelegraphLongAnimationPlayer")
@onready var triangle_animation = get_node("../TriangleTelegraphAnimationPlayer")
@onready var triangle_animation_2 = get_node("../TriangleTelegraphAnimationPlayer2")
@onready var boss_attack_animation = get_node("../BossAttackAnimationPlayer")
@onready var boss_attack_animation_2 = get_node("../BossAttackAnimationPlayer2")
@onready var sword_animation = get_node("../SwordAnimationPlayer")
@onready var screen_animation = get_node("../ScreenAnimationPlayer")
@onready var enrage_background = get_node("../EnrageBackground") 

@onready var cleave_aim = get_node("../Area2D/CleaveAim")
@onready var beam_aim: Marker2D = $BeamAim

@onready var animated_sprite_2d = get_node("../Area2D/CleaveAim/CleaveVFX/RedWind")
@onready var animated_sprite_2d_2 = get_node("../Area2D/CleaveAim/CleaveVFX/BlackWind")
@onready var animated_sprite_2d_3 = get_node("../Area2D/CleaveAim/CleaveVFX/BlackLightning")
@onready var fire_particles = get_node("../Area2D/CleaveAim/FireParticles2")
@onready var cleave_telegraph = get_node("../CleaveTelegraphAnimationPlayer")
@onready var attack_vfx_animation = get_node("../AttackVFXAnimation")
@onready var smoke: AnimatedSprite2D = $smoke

@onready var healthbar: ProgressBar = $CanvasLayer/Healthbar

@onready var lightning_1_triangle_0 = get_node("../Area2D/Triangle0VFX/Lightning1")
@onready var lightning_2_triangle_0 = get_node("../Area2D/Triangle0VFX/Lightning2")
@onready var lightning_3_triangle_0 = get_node("../Area2D/Triangle0VFX/Marker2D/Lightning3")

@onready var lightning_1_triangle_1 = get_node("../Area2D/Triangle1VFX/Lightning1")
@onready var lightning_2_triangle_1 = get_node("../Area2D/Triangle1VFX/Lightning2")
@onready var lightning_3_triangle_1 = get_node("../Area2D/Triangle1VFX/Marker2D/Lightning3")

@onready var lightning_1_triangle_2 = get_node("../Area2D/Triangle2VFX/Lightning1")
@onready var lightning_2_triangle_2 = get_node("../Area2D/Triangle2VFX/Lightning2")
@onready var lightning_3_triangle_2 = get_node("../Area2D/Triangle2VFX/Marker2D/Lightning3")

@onready var lightning_1_triangle_3 = get_node("../Area2D/Triangle3VFX/Lightning1")
@onready var lightning_2_triangle_3 = get_node("../Area2D/Triangle3VFX/Lightning2")
@onready var lightning_3_triangle_3 = get_node("../Area2D/Triangle3VFX/Marker2D/Lightning3")

@onready var lightning_1_triangle_4 = get_node("../Area2D/Triangle4VFX/Lightning1")
@onready var lightning_2_triangle_4 = get_node("../Area2D/Triangle4VFX/Lightning2")
@onready var lightning_3_triangle_4 = get_node("../Area2D/Triangle4VFX/Marker2D/Lightning3")

@onready var lightning_1_triangle_5 = get_node("../Area2D/Triangle5VFX/Lightning1")
@onready var lightning_2_triangle_5 = get_node("../Area2D/Triangle5VFX/Lightning2")
@onready var lightning_3_triangle_5 = get_node("../Area2D/Triangle5VFX/Marker2D/Lightning3")

@onready var outer_collision: CollisionPolygon2D = $"../Area2D/OuterCollision"

@onready var morph_vfx: AnimatedSprite2D = $MorphVFX
@onready var morph_vfx_2: AnimatedSprite2D = $MorphVFX2

@onready var beam_timer: Timer = $BeamTimer
@onready var beam_progress: Node2D = $BeamProgress

@onready var chain_tiles_audio: AudioStreamPlayer2D = $ChainTilesAudio
@onready var cleave_audio: AudioStreamPlayer2D = $CleaveAudio
@onready var line_aoe_audio: AudioStreamPlayer2D = $LineAOEAudio
@onready var beam_audio: AudioStreamPlayer2D = $BeamAudio
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var dash_audio: AudioStreamPlayer2D = $DashAudio
@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

@onready var idle: Node2D = $FiniteStateMachine/Idle
@onready var beam: Node2D = $FiniteStateMachine/Beam
@onready var forward_cleave: Node2D = $FiniteStateMachine/ForwardCleave
@onready var teleport_to_center: Node2D = $FiniteStateMachine/TeleportToCenter
@onready var chain_tiles: Node2D = $FiniteStateMachine/ChainTiles
@onready var chain_destruction: Node2D = $FiniteStateMachine/ChainDestruction
@onready var discharge: Node2D = $FiniteStateMachine/Discharge
@onready var discharge_double: Node2D = $FiniteStateMachine/DischargeDouble
@onready var line_aoe: Node2D = $FiniteStateMachine/LineAOE
@onready var walk_to_center: Node2D = $FiniteStateMachine/WalkToCenter
@onready var morph_out: Node2D = $FiniteStateMachine/MorphOut
@onready var morph_in: Node2D = $FiniteStateMachine/MorphIn
@onready var heartmind: Node2D = $FiniteStateMachine/Heartmind
@onready var follow: Node2D = $FiniteStateMachine/Follow
@onready var combo_surge: Node2D = $FiniteStateMachine/ComboSurge
@onready var enrage: Node2D = $FiniteStateMachine/Enrage
@onready var final_discharge: Node2D = $FiniteStateMachine/FinalDischarge


@onready var boss_killed = get_node("../BossKilled")
@onready var boss_death: bool = false

# flash particles
@onready var sprite = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var flash_timer: Timer = $FlashTimer
@onready var hit_particles: AnimatedSprite2D = $HitParticles2
@onready var jump_wind: AnimatedSprite2D = $JumpWind
@onready var marker_2d: Marker2D = $Marker2D
@onready var dash_particles: GPUParticles2D = $DashParticles

@onready var enrage_fire: GPUParticles2D = $EnrageFire
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop

#@onready var spit_aim: Marker2D = $SpitAim

@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow

@onready var beam_circle_timer: Timer = $BeamCircleTimer
#var circle_ref: Node2D
var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_fade.tscn")
var MeleeSpecial2 = preload("res://Other/melee_special_part_2.tscn")
var MeleeAuto = preload("res://Utilities/Effects/lightningvfx/MeleeSlamVFX.tscn")
var circle_ref: Node2D

var direction : Vector2
var move_speed = 60 #120

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 57000 : set = _set_health #57000
var center_of_screen = get_viewport_rect().size / 2

var timeline: int = 0
var paused = false
var beam_count: int = 0
var line_aoe_count: int = 0
var cleave_count: int = 0
var discharge_count: int = 0
var walk_center_count: int = 0
var enraged: bool = false
var beam_rotation: Vector2

var target_position = center_of_screen + Vector2(cos(deg_to_rad(-90)),sin(deg_to_rad(-90))) * 100
var opposite_position = center_of_screen + Vector2(cos(deg_to_rad(90)),sin(deg_to_rad(90))) * 100

signal main_boss_finished

#var pick_top_bottom = randi_range(1, 2)
#var pick_ns_ew = randi_range(1, 2)
#var spit_enrage: bool = false

func _ready():
	randomize()
	set_physics_process(false)
	healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	#player.charge_icon_disable()
	hit_particles.frame = 0
	connect("main_boss_finished", _main_boss_finished)
	enraged = false
	beam_count = 0
	dash_particles.emitting = false
	enrage_fire.visible = false

#func _process(delta):
	#if beam_circle_timer.time_left > 0:
		#circle_ref.global_position = player.global_position
	#if beam_timer.time_left > 0:
		#beam_rotation = player.global_position - global_position
		#beam_aim.rotation = beam_aim.global_position.angle_to_point(player.global_position)
		
func _physics_process(delta):
	velocity = direction.normalized() * move_speed
	position += velocity * delta
	move_and_slide()
	

func _set_health(value):
	health_amount = value
	healthbar.health = health_amount
	
func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void: 
	sprite.material.set_shader_parameter("flash_modifier", 0)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	GlobalCount.healthbar.apply_shake(1, 10.0)
	if area.name == "HitBox":
		health_amount -= player.damage_amount
		GlobalCount.dps_count += player.damage_amount
		flash()
		hit_particles.rotation = position.angle_to_point(player.position) + PI + 45
		#hit_particles.rotation = position.angle_to_point(player.position) + PI
		marker_2d.rotation = position.angle_to_point(player.position) + PI
		
		sword_particles.emitting = true
		slash_particles.emitting = true
		slash_glow.emitting = true
		#hit_particles.emitting = true
		hit_particles.play("hit_particles")
		
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
			player.abyssal_surge_hit.play()
		else:
			player.hit.play()
		
		if player.mana < 20:
			player.mana += 1
			if player.mana >= 20:
				player.charge_icon_disable()
				player.transform_icon_disable()
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
	elif area.name == "HeavyHitBox":
		health_amount -= (player.damage_amount * 4) #4
		GlobalCount.dps_count += (player.damage_amount * 4) #4
		flash()
		
		hit_particles.rotation = position.angle_to_point(player.position) + PI + 45
		#hit_particles.rotation = position.angle_to_point(player.position) + PI
		marker_2d.rotation = position.angle_to_point(player.position) + PI
		
		sword_particles.emitting = true
		slash_particles.emitting = true
		slash_glow.emitting = true
		#hit_particles.emitting = true
		hit_particles.play("hit_particles")
		
		if player.swing.playing:
			player.swing.stop()
		
		player.heavy_hit.play()
		
		if player.mana < 20:
			player.mana += 4 #4
			if player.mana >= 20:
				player.charge_icon_disable()
				player.transform_icon_disable()
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
		
	if health_amount <= 0:
		player.hurtbox_slash_collision.call_deferred("set", "disabled", true)
		player.hurtbox_collision.call_deferred("set", "disabled", true)
		
		hurtbox.call_deferred("set", "disabled", true)
		
		boss_attack_animation.queue_free()
		triangle_animation_long.queue_free()
		triangle_animation.queue_free()
		triangle_animation_2.queue_free()
		boss_attack_animation_2.queue_free()
		sword_animation.queue_free()
		#top_bottom_animation_player.queue_free()
		#in_out_animation_player.queue_free()
		animation_player.stop()
		
		attack_meter.queue_free()
		player.hurtbox_collision.disabled = true
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")
		remove_states()
		
func remove_states():
	idle.queue_free()
	beam.queue_free()
	forward_cleave.queue_free()
	teleport_to_center.queue_free()
	chain_tiles.queue_free()
	chain_destruction.queue_free()
	discharge.queue_free()
	discharge_double.queue_free()
	line_aoe.queue_free()
	walk_to_center.queue_free()
	morph_out.queue_free()
	morph_in.queue_free()
	heartmind.queue_free()
	follow.queue_free()
	combo_surge.queue_free()
	enrage.queue_free()
	final_discharge.queue_free()
	dash_particles.queue_free()
	healthbar.queue_free()

func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
func cleave_rotate():
	cleave_aim.position = position
	#cleave_animation.position = position
	cleave_aim.rotation = cleave_aim.position.angle_to_point(center_of_screen)
	#cleave_animation.rotation = cleave_aim.position.angle_to_point(Vector2(0, 0))
	#cleave_animation.rotation = cleave_aim.global_position.angle_to_point(Vector2(0, 0))
	
func cleave_vfx():
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
	animated_sprite_2d_3.play("default")
	fire_particles.emitting = true
	
func beam_rotate():
	beam_aim.rotation = beam_aim.global_position.angle_to_point(player.global_position)
	
func _main_boss_finished():
	boss_ranged.find_child("FiniteStateMachine").change_state("MorphIn")
	boss_melee.find_child("FiniteStateMachine").change_state("MorphIn")
	
func morph_apart_health():
	boss_melee.health_amount = self.health_amount
	boss_ranged.health_amount = self.health_amount
	healthbar_fade_animation_player.play("health_fade_out")
	
func melee_auto():
	var melee_attack = MeleeAuto.instantiate()
	melee_attack.position = player.position
	add_child(melee_attack)
	
func melee_slam_special(position: Vector2):
	var melee_slam = MeleeSpecial2.instantiate()
	melee_slam.position = position
	add_child(melee_slam)
	
func jump_vfx():
	jump_wind.play("default")
