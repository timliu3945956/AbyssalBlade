extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_2_melee = get_parent().find_child("Boss2Melee")
@onready var boss_2_main = get_parent().find_child("Boss2")
@onready var boss_room = get_node("..")
#@onready var collision: CollisionShape2D = $SlashHitBox/CollisionShape2D
#@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D


#@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D


@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var beam_animation_player: AnimationPlayer = $BeamAnimationPlayer
@onready var morph_animation: AnimationPlayer = $MorphAnimationPlayer

@onready var beam_rotation: Node2D = $BeamRotation

#@onready var tether_animation_player: AnimationPlayer = $TetherAnimationPlayer

@onready var boss_room_animation = get_node("../BossAttackAnimationPlayer")
@onready var attack_meter_animation = get_node("../AttackMeterAnimationPlayer")

#@onready var boss_jump_timer: Timer = $BossJumpTimer

@onready var boss_killed = get_node("../BossKilled")
@onready var boss_death: bool = false

@onready var vfx_timer: Timer = $VFXTimer


# flash particles
@onready var sprite = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow

@onready var flash_timer: Timer = $FlashTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var jump_wind: AnimatedSprite2D = $JumpWind

@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2

#@onready var spit_aim: Marker2D = $SpitAim
@onready var boss_healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar

@onready var smoke: AnimatedSprite2D = $smoke

var hit_particle = preload("res://Other/hit_particles.tscn")
var darkness_balance_vfx = preload("res://Other/darkness_balance_vfx.tscn")

var direction : Vector2
var move_speed = 120
var spit_count: int = 0

var foretold_count: int = 0
var jump_position_count: int = 0
var auto_attack_count: int = 0

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 37000 : set = _set_health
var center_of_screen = get_viewport_rect().size / 2 

var timeline: int = 0

var balance_counter: int = 0

func _ready():
	randomize()
	set_physics_process(false)
	boss_healthbar.init_health(health_amount)
	GlobalCount.can_pause = true

#func _process(_delta):
	#if spit_attack_follow_timer.time_left > 0:
		#spit_aim.rotation = spit_aim.global_position.angle_to_point(player.global_position)
#
	#if boss_jump_timer.time_left > 0:
		#position = player.position
		#jump_slam_attack.global_position = player.global_position
func _physics_process(_delta):
	velocity = direction.normalized() * move_speed
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
	boss_healthbar.apply_shake(1, 10.0)
	if area.name == "HitBox":
		health_amount -= player.damage_amount #additional *4
		GlobalCount.dps_count += player.damage_amount #additional *4
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
		
	if health_amount <= 1:
		#player.hurtbox_slash_collision.call_deferred("set", "disabled", true)
		#player.hurtbox_collision.call_deferred("set", "disabled", true)
		#
		#hurtbox.call_deferred("set", "disabled", true)
		#
		#boss_room_animation.queue_free()
		##top_bottom_animation_player.queue_free()
		##in_out_animation_player.queue_free()
		#animation_player.stop()
		#
		#attack_meter.queue_free()
		#boss_death = true
		#find_child("FiniteStateMachine").change_state("Death")
		health_amount = 1
		
func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)

func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func ranged_special_finish():
	boss_2_melee.find_child("FiniteStateMachine").change_state("JumpPosition")
	find_child("FiniteStateMachine").change_state("JumpPosition")
		
func jump_vfx():
	jump_wind.play("default")

func arena_death_vfx():
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	
func smoke_vfx():
	smoke.play("smoke")

func darkness_balance_vfx_spawn():
	var spawn_vfx = darkness_balance_vfx.instantiate()
	spawn_vfx.position = Vector2(0, -11)
	add_child(spawn_vfx)

func _on_vfx_timer_timeout() -> void:
	darkness_balance_vfx_spawn()
