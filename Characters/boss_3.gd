extends CharacterBody2D

@onready var player = get_parent().find_child("Player")

@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D

@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrage_symbol_animation: AnimationPlayer = $BarrageSymbolAnimation
@onready var protean_animation_player: AnimationPlayer = $DestructiveProtean/ProteanAnimationPlayer
@onready var sword_animation_player: AnimationPlayer = $SwordAnim/SwordAnimationPlayer

@onready var boss_room = get_node("..")
@onready var attack_meter_animation = get_node("../AttackMeterAnimation")
@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var boss_room_animation2 = get_node("../BossRoomAnimationPlayer2")
@onready var enrage_background = get_node("../EnrageBackground")

@onready var black_smoke_symbol_anim: AnimatedSprite2D = $Node2D/BlackSmokeSymbolAnim

#state machine for queue freeing
@onready var idle: Node2D = $FiniteStateMachine/Idle
@onready var barrage: Node2D = $FiniteStateMachine/Barrage
@onready var oppressive: Node2D = $FiniteStateMachine/Oppressive
@onready var depressive_thoughts: Node2D = $FiniteStateMachine/DepressiveThoughts
@onready var destructive_thoughts: Node2D = $FiniteStateMachine/DestructiveThoughts
@onready var devour: Node2D = $FiniteStateMachine/Devour
@onready var looming_havoc: Node2D = $FiniteStateMachine/LoomingHavoc
@onready var engulfing_curse: Node2D = $FiniteStateMachine/EngulfingCurse
@onready var barrage_opposite: Node2D = $FiniteStateMachine/BarrageOpposite
@onready var wreak_havoc: Node2D = $FiniteStateMachine/WreakHavoc
@onready var existential_crisis: Node2D = $FiniteStateMachine/ExistentialCrisis
@onready var phase_2: Node2D = $FiniteStateMachine/Phase2
@onready var enrage: Node2D = $FiniteStateMachine/Enrage


@onready var boss_killed = get_node("../BossKilled")
@onready var boss_death: bool = false

@onready var enrage_fire: GPUParticles2D = $EnrageFire
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop

# DESTRUCTIVE THOUGHTS
@onready var protean_rotate: Marker2D = $DestructiveProtean/ProteanRotate
@onready var protean_follow_timer: Timer = $DestructiveProtean/ProteanFollowTimer
@onready var spit_attack_white: AnimatedSprite2D = $DestructiveProtean/ProteanRotate/ProteanVFX/SpitAttackWhite
@onready var spit_attack_red: AnimatedSprite2D = $DestructiveProtean/ProteanRotate/ProteanVFX/SpitAttackRed


#Sword colors
@onready var red_swords: Sprite2D = $SwordAnim/RedSwords
#@onready var black_swords: Sprite2D = $SwordAnim/BlackSwords
#@onready var white_swords: Sprite2D = $SwordAnim/WhiteSwords
@onready var black_white_swords: Sprite2D = $SwordAnim/BlackWhiteSwords
@onready var white_black_swords: Sprite2D = $SwordAnim/WhiteBlackSwords
@onready var black_swords: AnimatedSprite2D = $SwordAnim/BlackSwords
@onready var white_swords: AnimatedSprite2D = $SwordAnim/WhiteSwords

#Crown Colors
@onready var white_crown: Sprite2D = $WhiteCrown
@onready var black_crown: Sprite2D = $BlackCrown
@onready var red_crown: Sprite2D = $RedCrown
@onready var white_crown_expand: Sprite2D = $WhiteCrownExpand
@onready var black_crown_expand: Sprite2D = $BlackCrownExpand
@onready var red_crown_expand: Sprite2D = $RedCrownExpand
@onready var crown_appear_vfx: AnimatedSprite2D = $CrownAppearVFX

@onready var death_particles: AnimatedSprite2D = $DeathParticles

# flash particles
@onready var sprite = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer
@onready var hit_particles: AnimatedSprite2D = $HitParticles2
@onready var marker_2d: Marker2D = $Marker2D

@onready var dust_anim: AnimatedSprite2D = $DustAnim

@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow

@onready var phase_2_audio: AudioStreamPlayer2D = $phase_2_audio

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

@onready var healthbar = $CanvasLayer/Healthbar

var direction : Vector2
var move_speed = 60 #120
var barrage_count: int = 0
var oppressive_count : int = 0
var wreak_havoc_count : int = 0
var barrage_opposite_count: int = 0
var looming_count: int = 0
var barrage_pick_phase_2: int = randi_range(1, 2)
var barrage_pick: int = randi_range(1, 2)
var oppressive_pick: int = randi_range(1, 2) #1 means white is left, blk is right,,, 2 means blk is left, white is right

var left_color: String
var right_color: String
var oppressive_debuff_count: int = 0
var oppressive_current_count: int
var crown_color: String

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 90000 : set = _set_health
var center_of_screen = get_viewport_rect().size / 2 

var timeline: int = 0

var DepressionPillar = preload("res://Other/DepressionPillar.tscn")
var DepressionPillar2 = preload("res://Other/DepressionPillar2.tscn")

func _ready():
	randomize()
	set_physics_process(false)
	healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	
	hit_particles.frame = 0
	enrage_fire_pop.emitting = false
	print("oppressive randi_range: ", oppressive_pick)
	
	dust_anim.modulate.a = 1
	
	red_swords.modulate.a = 0
	black_swords.modulate.a = 0
	white_swords.modulate.a = 0
	black_white_swords.modulate.a = 0
	white_black_swords.modulate.a = 0
	
	red_crown.modulate.a = 0
	black_crown.modulate.a = 0
	white_crown.modulate.a = 0
	red_crown_expand.modulate.a = 0
	black_crown_expand.modulate.a = 0
	white_crown_expand.modulate.a = 0

func _process(_delta):
	if protean_follow_timer.time_left > 0:
		protean_rotate.rotation = protean_rotate.global_position.angle_to_point(player.global_position)

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
		
		#boss_room_animation.queue_free()
		#top_bottom_animation_player.queue_free()
		#in_out_animation_player.queue_free()
		animation_player.stop()
		
		attack_meter.queue_free()
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")
		remove_state()
		
func remove_state():
	idle.queue_free()
	barrage.queue_free()
	oppressive.queue_free()
	depressive_thoughts.queue_free()
	destructive_thoughts.queue_free()
	devour.queue_free()
	looming_havoc.queue_free()
	engulfing_curse.queue_free()
	barrage_opposite.queue_free()
	wreak_havoc.queue_free()
	existential_crisis.queue_free()
	phase_2.queue_free()
	enrage.queue_free()
	healthbar.queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
func camera_shake_phase_2():
	GlobalCount.camera.apply_shake(5, 25.0)
	
# Dust fade for mechs
func dust_fade_in():
	var dust_tween = get_tree().create_tween()
	dust_tween.tween_property(dust_anim, "modulate:a", 1.0, 0.3)
func dust_fade_out():
	var dust_tween = get_tree().create_tween()
	dust_tween.tween_property(dust_anim, "modulate:a", 0, 0.3)
	
# functions for mechs
func barrage_pattern_1(): #in -> out -> +
	attack_meter_animation.play("barrage_1")
	
func barrage_pattern_2(): #out -> in -> X
	attack_meter_animation.play("barrage_2")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "barrage" or anim_name == "depressive":
		animation_player.play("idle")
	
		
func protean_hit_vfx():
	spit_attack_white.play("default")
	spit_attack_red.play("default")
