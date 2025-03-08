extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_2_ranged = get_parent().find_child("Boss2Ranged")
@onready var boss_2_main = get_parent().find_child("Boss2")
@onready var boss_room = get_node("..")

#@onready var collision: CollisionShape2D = $SlashHitBox/CollisionShape2D
#@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D


#@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D

@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var slam_telegraph_player: AnimationPlayer = $SlamTelegraphPlayer
@onready var morph_animation: AnimationPlayer = $MorphAnimationPlayer

@onready var darkness_balance: AudioStreamPlayer2D = $DarknessBalance
@onready var darkness_fail: AudioStreamPlayer2D = $DarknessFail


#@onready var tether_animation_player: AnimationPlayer = $TetherAnimationPlayer
@onready var boss_room_animation = get_node("../BossAttackAnimationPlayer")
@onready var attack_meter_animation = get_node("../AttackMeterAnimationPlayer")
@onready var enrage_background = get_node("../EnrageBackground")

@onready var healthbar_fade_animation_player = get_node("../HealthbarFadeAnimationPlayer")
@onready var screen_animation = get_node("../ScreenAnimationPlayer")

@onready var jump_slam_attack: Sprite2D = $JumpSlamAttack
@onready var slam_attack: AnimatedSprite2D = $JumpSlamAttack/SlamAttack
@onready var slam_attack_2: AnimatedSprite2D = $JumpSlamAttack/SlamAttack2
@onready var slam_particles: GPUParticles2D = $JumpSlamAttack/SlamParticles

@onready var laser_line = get_node("../LaserMiddle")
@onready var pain_line: Timer = $PainLine

@onready var jump_timer: Timer = $JumpTimer

@onready var boss_killed = get_node("../BossKilled")
@onready var boss_death: bool = false

# flash particles
@onready var sprite = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var flash_timer: Timer = $FlashTimer
@onready var hit_particles: AnimatedSprite2D = $HitParticles2
@onready var marker_2d: Marker2D = $Marker2D
@onready var jump_wind: AnimatedSprite2D = $JumpWind

@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2

#@onready var spit_aim: Marker2D = $SpitAim

@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow

@onready var healthbar = $CanvasLayer/Healthbar

@onready var smoke: AnimatedSprite2D = $smoke


var direction : Vector2
var move_speed = 100
var spit_count: int = 0
var auto_attack_count: int = 0
var jump_position_count: int = 0
# Change healthbar value as well to change healthbar health: 37500
var health_amount = 60000 : set = _set_health

var center_of_screen = get_viewport_rect().size / 2 
var max_health = 60000
var allowed_diff = max_health * 0.05
var foretold_count: int = 0
var timeline: int = 0

var enraged = false
var paused = false

var was_hit_this_frame = false

var balance_counter: int = 0
#var spit_enrage: bool = false
var pick_mini_special = randi_range(1, 2) #1. melee goes first, 2. ranged goes first
var pick_foretold = randi_range(1, 2)
signal mini_bosses_finished

func _ready():
	randomize()
	set_physics_process(false)
	healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	connect("mini_bosses_finished", _mini_bosses_finished)
	hit_particles.frame = 0
	enraged = false
	laser_line.emitting = false
	print(pick_mini_special)
	
	#spit_enrage = false

func _process(_delta):
	if pain_line.time_left > 0:
		var ranged_health = boss_2_ranged.health_amount
		var difference = abs(health_amount - ranged_health)
		#print(laser_line.emitting)
		#print("difference: ", difference > allowed_diff)
		if difference > allowed_diff:
			laser_line.emitting = false
		else:
			laser_line.emitting = true
	#if spit_attack_follow_timer.time_left > 0:
		#spit_aim.rotation = spit_aim.global_position.angle_to_point(player.global_position)

	if jump_timer.time_left > 0:
		position = player.position
		#jump_slam_attack.global_position = player.global_position
func _physics_process(_delta):
	velocity = direction.normalized() * move_speed
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
		health_amount -= player.damage_amount #additional *4
		GlobalCount.dps_count += player.damage_amount #additional *4
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
		
		boss_room_animation.queue_free()
		#top_bottom_animation_player.queue_free()
		#in_out_animation_player.queue_free()
		animation_player.stop()
		
		attack_meter.queue_free()
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")

func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
#func slam_attack_animation():
	#slam_attack.play("new_animation")
	#slam_attack_2.play("default")
	#slam_particles.emitting = true
	#
	
	
#func jump_slam_position():
	#position = player.position
	#jump_slam_attack.global_position = player.global_position
	
func hands_of_pain():
	if boss_2_ranged == null:
		return
	
	var ranged_health = boss_2_ranged.health_amount
	var difference = abs(health_amount - ranged_health)
	var allowed_diff = max_health * 0.05
	
	if difference > allowed_diff:
		#boss_room.arena_death_vfx()
		arena_death_vfx()
		boss_2_ranged.arena_death_vfx()
		player.kill_player()
	else:
		boss_room_animation.play("balance_correct")
		darkness_balance.play()
		darkness_fail.play()
		
func pain_line_timer():
	pain_line.start()
	
func _on_pain_line_timeout() -> void:
	laser_line.emitting = false
	
func morph_together_health():
	if self.health_amount < boss_2_ranged.health_amount:
		boss_2_main.health_amount = self.health_amount
	elif self.health_amount > boss_2_ranged.health_amount:
		boss_2_main.health_amount = boss_2_ranged.health_amount
	else:
		boss_2_main.health_amount = self.health_amount
		
	healthbar_fade_animation_player.play("health_fade_in")

func _mini_bosses_finished():
	boss_2_main.find_child("FiniteStateMachine").change_state("MorphIn")

func finish_wicked_heart():
	#if pick_mini_special == 1:
	boss_2_ranged.find_child("FiniteStateMachine").change_state("JumpPosition")
	find_child("FiniteStateMachine").change_state("JumpPosition")
	#else:
		#boss_2_ranged.position = owner.center_of_screen + Vector2(50, 0)
		#boss_2_ranged.animation_player.play("jump_land")
		#await boss_2_ranged.animation_player.animation_finished
		#boss_2_ranged.animation_player.play("idle_left")
		#await get_tree().create_timer(1.5833).timeout
		#boss_2_ranged.find_child("FiniteStateMachine").change_state("RightPosition") #RightPosition
		
func jump_vfx():
	jump_wind.play("default")
	
func arena_death_vfx():
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	
func smoke_vfx():
	smoke.play("smoke")
