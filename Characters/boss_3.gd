extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_room = get_node("..")
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D2
@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D

@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrage_symbol_animation: AnimationPlayer = $BarrageSymbolAnimation
@onready var protean_animation_player: AnimationPlayer = $DestructiveProtean/ProteanAnimationPlayer
@onready var sword_animation_player: AnimationPlayer = $SwordAnim/SwordAnimationPlayer


@onready var attack_meter_animation = get_node("../AttackMeterAnimation")
@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var boss_room_animation2 = get_node("../BossRoomAnimationPlayer2")
@onready var enrage_background = get_node("../EnrageBackground")
@onready var boss_death_anim = get_node("../BossDeathAnimation")

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
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var sword_anim: Node2D = $SwordAnim

@onready var node_2d: Node2D = $Node2D


@onready var boss_killed = get_node("../Portal")
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
@onready var black_fire_spawn: AnimatedSprite2D = $SwordAnim/BlackFireSpawn
@onready var black_fire_spawn_2: AnimatedSprite2D = $SwordAnim/BlackFireSpawn2
@onready var white_fire_spawn: AnimatedSprite2D = $SwordAnim/WhiteFireSpawn
@onready var white_fire_spawn_2: AnimatedSprite2D = $SwordAnim/WhiteFireSpawn2

@onready var knockback_effect: AnimatedSprite2D = $Devour/KnockbackEffect


#Crown Colors
@onready var white_crown: Sprite2D = $WhiteCrown
@onready var black_crown: Sprite2D = $BlackCrown
@onready var red_crown: Sprite2D = $RedCrown
@onready var white_crown_expand: Sprite2D = $WhiteCrownExpand
@onready var black_crown_expand: Sprite2D = $BlackCrownExpand
@onready var red_crown_expand: Sprite2D = $RedCrownExpand
@onready var crown_appear_vfx: AnimatedSprite2D = $CrownAppearVFX

@onready var crown_aura_black: AnimatedSprite2D = $CrownAuraBlack
@onready var crown_aura_white: AnimatedSprite2D = $CrownAuraWhite
@onready var crown_aura_red: AnimatedSprite2D = $CrownAuraRed


@onready var death_particles: AnimatedSprite2D = $DeathParticles

@onready var devour_meter: Node2D = $DevourMeter
@onready var label: Label = $DevourMeter/Label
@onready var devour_bar: TextureProgressBar = $DevourMeter/TextureProgressBar
@onready var devour_meter_player: AnimationPlayer = $DevourMeterPlayer
@onready var devour_start_audio: AudioStreamPlayer2D = $DevourStartAudio
@onready var knockback_audio: AudioStreamPlayer2D = $KnockbackAudio

@onready var first_purple_vfx: AnimatedSprite2D = $PurpleOrbDebuff/FirstPurpleVFX
@onready var second_purple_vfx: AnimatedSprite2D = $PurpleOrbDebuff/SecondPurpleVFX
@onready var purple_orb_vfx_timer: Timer = $PurpleOrbDebuff/PurpleOrbVFXTimer

# flash particles
@onready var sprite = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer

@onready var dust_anim: AnimatedSprite2D = $DustAnim


@onready var barrage_audio: AudioStreamPlayer2D = $BarrageAudio
@onready var oppressive_audio: AudioStreamPlayer2D = $OppressiveAudio
@onready var unleash_crown_audio: AudioStreamPlayer2D = $UnleashCrownAudio
@onready var phase_2_audio: AudioStreamPlayer2D = $phase_2_audio
@onready var symbol_change_audio: AudioStreamPlayer2D = $SymbolChangeAudio

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

@onready var boss_healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar

var hit_particle = preload("res://Other/hit_particles.tscn")

var direction : Vector2
var move_speed = 60 #120
var barrage_count: int = 0
var oppressive_count : int = 0
var wreak_havoc_count : int = 0
var barrage_opposite_count: int = 0
var looming_count: int = 0

var barrage_third_pick: int = randi_range(1, 2)

var barrage_pick_phase_2: int = randi_range(1, 2)
var barrage_pick: int = randi_range(1, 2)
var oppressive_pick: int = randi_range(1, 2) #1 means white is left, blk is right,,, 2 means blk is left, white is right

var left_color: String
var right_color: String
var oppressive_debuff_count: int = 0
var oppressive_current_count: int
var crown_color: String

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 60000 : set = _set_health #61000
var center_of_screen = get_viewport_rect().size / 2 

var timeline: int = 0

var DepressionPillar = preload("res://Other/DepressionPillar.tscn")
var DepressionPillar2 = preload("res://Other/DepressionPillar2.tscn")

var _last_t : int

func _ready():
	randomize()
	set_physics_process(false)
	boss_healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	GlobalCount.can_charge = false
	
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
	
	crown_aura_black.modulate.a = 0
	crown_aura_white.modulate.a = 0
	crown_aura_red.modulate.a = 0
	
	black_smoke_symbol_anim.self_modulate.a = 0
	devour_meter.modulate.a = 0
	boss_room.ground_aura()
	_last_t = Time.get_ticks_usec()

func _process(_delta):
	var now := Time.get_ticks_usec()
	var dt := float(now - _last_t) * 1e-6
	_last_t = now
	boss_death_anim.advance(dt)
	
	if protean_follow_timer.time_left > 0:
		protean_rotate.rotation = protean_rotate.global_position.angle_to_point(player.global_position)

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
	white_crown.queue_free()
	black_crown.queue_free()
	red_crown.queue_free()
	white_crown_expand.queue_free()
	black_crown_expand.queue_free()
	red_crown_expand.queue_free()
	sword_anim.queue_free()
	dust_anim.queue_free()
	canvas_layer.queue_free()
	attack_meter.queue_free()
	crown_aura_black.queue_free()
	crown_aura_white.queue_free()
	crown_aura_red.queue_free()
	node_2d.queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func camera_shake_phase_2(): 
	GlobalCount.camera.apply_shake(12.0, 20.0)
	
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
	if anim_name == "barrage" or anim_name == "depressive" or anim_name == "imbuement" or anim_name == "devour_suck":
		animation_player.play("idle")
	
func protean_hit_vfx():
	spit_attack_white.play("default")
	spit_attack_red.play("default")
	
func orb_buff_vfx():
	first_purple_vfx.modulate.a = 1
	second_purple_vfx.modulate.a = 1
	purple_orb_vfx_timer.start()
	
	#var first_vfx = get_tree().create_tween()
	#first_vfx.tween_property(first_gold_vfx, "modulate:a", 1, 0.3)
	#var second_vfx = get_tree().create_tween()
	#second_vfx.tween_property(second_gold_vfx, "modulate:a", 1, 0.3)
	first_purple_vfx.play("default")

func orb_buff_vfx_off():
	var first_vfx = get_tree().create_tween()
	first_vfx.tween_property(first_purple_vfx, "modulate:a", 0, 0.2)
	var second_vfx = get_tree().create_tween()
	second_vfx.tween_property(second_purple_vfx, "modulate:a", 0, 0.2)
	
func _on_purple_orb_vfx_timer_timeout() -> void:
	second_purple_vfx.play("default")

func apply_knockback():
	if player:
		player.apply_knockback(center_of_screen + Vector2(240, 135), -250) #350 #-125
