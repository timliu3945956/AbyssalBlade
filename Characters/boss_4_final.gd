extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var boss_room = get_node("..")
@onready var meteor = get_parent().find_child("MeteorDrops")
@onready var boss_killed = get_node("../Portal")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var oppressive_animation_player: AnimationPlayer = $OppressiveAnimationPlayer

@onready var attack_meter_animation = get_node("../AttackMeterAnimation")
@onready var room_change_player = get_node("../RoomChangePlayer")
@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var boss_room_animation2 = get_node("../BossRoomAnimationPlayer2")
@onready var boss_1_animation = get_node("../Boss1AnimationPlayer")
@onready var boss_2_animation = get_node("../Boss2AnimationPlayer")
@onready var boss_3_animation = get_node("../Boss3AnimationPlayer")
@onready var boss_3_animation2 = get_node("../Boss3AnimationPlayer2")
@onready var boss_shadow_animation = get_node("../BossShadowAnimationPlayer")
@onready var denial_shadow = get_node("../Node2D2")
@onready var anger_shadow = get_node("../Node2D3")
@onready var bargain_shadow = get_node("../Node2D4")
@onready var depression_shadow = get_node("../Node2D5")
@onready var protean_animation_player: AnimationPlayer = $DestructiveProtean/ProteanAnimationPlayer
@onready var boss_death_anim = get_node("../BossDeathAnimation")

@onready var flash_room_animation = get_node("../FlashArenaAnimationPlayer")
@onready var circle_animation = get_node("../CircleAnimationPlayer")
@onready var enrage_animation = get_node("../EnrageBackground")
@onready var cutscene_player = get_node("../CutscenePlayer")
@onready var sword_animation_player: AnimationPlayer = $SwordAnimationPlayer
@onready var sword_animation_player_2: AnimationPlayer = $SwordAnimationPlayer2
@onready var oblivion_ball_animation: AnimationPlayer = $OblivionBallAnimation
@onready var cleave_sword_anim: AnimationPlayer = $CleaveSwordAnim
@onready var slam_attack: AnimatedSprite2D = $JumpSlamAttack/SlamAttack
@onready var slam_attack_2: AnimatedSprite2D = $JumpSlamAttack/SlamAttack2

@onready var sword_marker: Marker2D = $Marker2D

@onready var boss_healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar
@onready var healthbar: TextureProgressBar = $CanvasLayer/BossHealthbar/Healthbar
@onready var health_damage_bar: TextureProgressBar = $CanvasLayer/BossHealthbar/HealthDamageBar

@onready var sprite: Sprite2D = $Sprite
@onready var sprite_shadow: Sprite2D = $SpriteShadow

@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var attack_meter: Node2D = $AttackMeter

@onready var flash_timer: Timer = $FlashTimer
@onready var vfx_timer: Timer = $VFXTimer
@onready var protean_follow_timer: Timer = $DestructiveProtean/ProteanFollowTimer
@onready var protean_rotate: Marker2D = $DestructiveProtean/ProteanRotate
@onready var spit_attack_white: AnimatedSprite2D = $DestructiveProtean/ProteanRotate/ProteanVFX/SpitAttackWhite
@onready var spit_attack_red: AnimatedSprite2D = $DestructiveProtean/ProteanRotate/ProteanVFX/SpitAttackRed


@onready var boss_death: bool = false

#@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

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

@onready var knockback_effect_anger: AnimatedSprite2D = $KnockbackEffectAnger
@onready var knockback_audio: AudioStreamPlayer2D = $KnockbackAudio

@onready var smoke_1: AnimatedSprite2D = get_parent().get_node("SwordDrop1,1/smoke1")
@onready var smoke_2: AnimatedSprite2D = get_parent().get_node("SwordDrop1,2/smoke2")
@onready var smoke_3: AnimatedSprite2D = get_parent().get_node("SwordDrop1,3/smoke3")
@onready var smoke_4: AnimatedSprite2D = get_parent().get_node("SwordDrop1,4/smoke4")
@onready var smoke_5: AnimatedSprite2D = get_parent().get_node("SwordDrop2,1/smoke5")
@onready var smoke_6: AnimatedSprite2D = get_parent().get_node("SwordDrop2,2/smoke6")
@onready var smoke_7: AnimatedSprite2D = get_parent().get_node("SwordDrop2,3/smoke7")
@onready var smoke_8: AnimatedSprite2D = get_parent().get_node("SwordDrop2,4/smoke8")
@onready var smoke_9: AnimatedSprite2D = get_parent().get_node("SwordDrop3,1/smoke9")
@onready var smoke_10: AnimatedSprite2D = get_parent().get_node("SwordDrop3,2/smoke10")
@onready var smoke_11: AnimatedSprite2D = get_parent().get_node("SwordDrop3,3/smoke11")
@onready var smoke_12: AnimatedSprite2D = get_parent().get_node("SwordDrop3,4/smoke12")
@onready var smoke_13: AnimatedSprite2D = get_parent().get_node("SwordDrop4,1/smoke13")
@onready var smoke_14: AnimatedSprite2D = get_parent().get_node("SwordDrop4,2/smoke14")
@onready var smoke_15: AnimatedSprite2D = get_parent().get_node("SwordDrop4,3/smoke15")
@onready var smoke_16: AnimatedSprite2D = get_parent().get_node("SwordDrop4,4/smoke16")

@onready var blade_of_ruin_audio: AudioStreamPlayer2D = $BladeOfRuinAudio
@onready var octahit_audio: AudioStreamPlayer2D = $OctahitAudio
@onready var hope_safe_audio: AudioStreamPlayer2D = $HopeSafeAudio
@onready var oblivion_audio: AudioStreamPlayer2D = $OblivionAudio
@onready var constant_fire_audio: AudioStreamPlayer2D = $ConstantFireAudio
@onready var ravage_audio: AudioStreamPlayer2D = $RavageAudio
@onready var premonition_marker_audio: AudioStreamPlayer2D = $PremonitionMarkerAudio
@onready var premonition_symbol_audio: AudioStreamPlayer2D = $PremonitionSymbolAudio
@onready var oppressive_audio: AudioStreamPlayer2D = $OppressiveAudio

@onready var dash: AudioStreamPlayer2D = $dash

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var idle: Node2D = $FiniteStateMachine/Idle
@onready var ultimate_denial: Node2D = $FiniteStateMachine/UltimateDenial
@onready var ultimate_anger: Node2D = $FiniteStateMachine/UltimateAnger
@onready var ultimate_bargain: Node2D = $FiniteStateMachine/UltimateBargain
@onready var ultimate_depression: Node2D = $FiniteStateMachine/UltimateDepression
@onready var ultimate_grief: Node2D = $FiniteStateMachine/UltimateGrief
@onready var debug: Label = $debug
@onready var foreground_arena: Sprite2D = $"../ForegroundArena"
@onready var final_attack_aura: AnimatedSprite2D = $FinalAttackAura
@onready var devour_meter: Node2D = $DevourMeter
@onready var devour_bar: TextureProgressBar = $DevourMeter/TextureProgressBar
#@onready var knockback_effect: AnimatedSprite2D = $Devour/KnockbackEffect
@onready var symbol_change_audio: AudioStreamPlayer2D = $SymbolChangeAudio
@onready var devour_meter_player: AnimationPlayer = $DevourMeterPlayer
@onready var knockback_effect: AnimatedSprite2D = $Devour/KnockbackEffect


# AUDIO----------------------------------------------
@onready var dash_audio: AudioStreamPlayer2D = $DashAudio




var darkness_balance_vfx = preload("res://Other/darkness_balance_vfx.tscn")
var tether = preload("res://Other/Tether.tscn")
var cleave = preload("res://Other/half_room_cleave.tscn")
var triple_cleave = preload("res://Other/TripleCleave.tscn")
var hit_particle = preload("res://Other/hit_particles.tscn")
var enrage_sword = preload("res://Other/EnrageSword.tscn")
var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_fade.tscn")
var enrage_attack = preload("res://Other/Boss4EnrageAttack.tscn")
var DestructivePillar = preload("res://Other/DepressionPillar.tscn")
var DestructivePillar2 = preload("res://Other/DepressionPillar2.tscn")
var DestructivePillar3 = preload("res://Other/DepressionPillar3.tscn")
var DestructivePillar4 = preload("res://Other/DepressionPillar4.tscn")
var pillar
var pillar_2
var pillar_3
var pillar_4
var spawn_enrage_attack = enrage_attack.instantiate()
var circle_ref: Node2D

var center_of_screen = get_viewport_rect().size / 2 
var left_color: String
var right_color: String


var health_amount = GlobalCount.boss_4_final_health : set = _set_health #GlobalCount.boss_4_final_health
var direction : Vector2
var move_speed = 42.5 #120

var _last_t : int

func _ready() -> void:
	boss_healthbar.init_health(58000)
	healthbar.value = GlobalCount.boss_4_final_health
	health_damage_bar.value = GlobalCount.boss_4_final_health
	
	devour_meter.modulate.a = 0
	_last_t = Time.get_ticks_usec()

func _process(delta: float) -> void:
	var now := Time.get_ticks_usec()
	var dt := float(now - _last_t) * 1e-6
	_last_t = now
	boss_death_anim.advance(dt)
	
	if protean_follow_timer.time_left > 0:
		protean_rotate.rotation = protean_rotate.global_position.angle_to_point(player.global_position)
	#if sword_follow_timer.time_left > 0:
		#sword_marker_main.rotation = sword_marker_main.global_position.angle_to_point(player.global_position)
		
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
		player.set_process(false)
		player.set_physics_process(false)
		sprite.start_shake(1.8, 0.2)
		player.high_pitch_slice_audio.play()
		boss_death_anim.play("death")
		boss_death = true
		AudioPlayer.fade_out_music(3)
		HitStopManager.hit_stop_boss_death_final()
		#player.hurtbox_slash_collision.call_deferred("set", "disabled", true)
		#player.hurtbox_collision.call_deferred("set", "disabled", true)
		
		hurtbox.call_deferred("set", "disabled", true)
		
		#boss_room_animation.queue_free()
		#top_bottom_animation_player.queue_free()
		#in_out_animation_player.queue_free()
		animation_player.stop()
		
		
		remove_state()
		find_child("FiniteStateMachine").change_state("Death")
		
		
func remove_state():
	attack_meter_animation.play("RESET")
	#room_change_player.stop()
	#boss_room_animation.stop()
	#boss_room_animation2.stop()
	#boss_1_animation.stop()
	#boss_2_animation.stop()
	#boss_3_animation.stop()
	#boss_3_animation2.stop()
	boss_shadow_animation.play("RESET")
	attack_meter.queue_free()
	canvas_layer.queue_free()
	idle.queue_free()
	ultimate_denial.queue_free()
	ultimate_anger.queue_free()
	ultimate_bargain.queue_free()
	ultimate_depression.queue_free()
	ultimate_grief.queue_free()
	attack_meter_animation.queue_free()
	room_change_player.queue_free()
	boss_room_animation.queue_free()
	boss_room_animation2.queue_free()
	boss_1_animation.queue_free()
	boss_2_animation.queue_free()
	boss_3_animation.queue_free()
	boss_3_animation2.queue_free()
	denial_shadow.queue_free()
	anger_shadow.queue_free()
	bargain_shadow.queue_free()
	depression_shadow.queue_free()
	boss_shadow_animation.queue_free()
	
	if is_instance_valid(spawn_enrage_attack):
		spawn_enrage_attack.queue_free()
	if is_instance_valid(boss_room.range_line):
		boss_room.range_line.queue_free()
	if is_instance_valid(boss_room.range_line_first):
		boss_room.range_line.queue_free()
	if is_instance_valid(boss_room.telegraphs):
		boss_room.telegraphs.queue_free()
	if is_instance_valid(boss_room.boss_1_collision_vfx):
		boss_room.boss_1_collision_vfx.queue_free()
	if is_instance_valid(boss_room.boss_2_collision_vfx):
		boss_room.boss_2_collision_vfx.queue_free()
	if is_instance_valid(boss_room.oppressive_vfx):
		boss_room.oppressive_vfx.queue_free()
	if is_instance_valid(boss_room.area_attacks):
		boss_room.area_attacks.queue_free()
	if is_instance_valid(pillar):
		pillar.queue_free()
	if is_instance_valid(pillar_2):
		pillar_2.queue_free()
	if is_instance_valid(pillar_3):
		pillar_3.queue_free()
	if is_instance_valid(pillar_4):
		pillar_4.queue_free()
		
	boss_room.circle_0_light.queue_free()
	boss_room.circle_1_light.queue_free()
	boss_room.circle_2_light.queue_free()
	boss_room.circle_3_light.queue_free()
	boss_room.circle_4_light.queue_free()
	boss_room.circle_5_light.queue_free()
	boss_room.circle_6_light.queue_free()
	boss_room.circle_7_light.queue_free()
	boss_room.sword_drop_1_1.queue_free()
	boss_room.sword_drop_1_2.queue_free()
	boss_room.sword_drop_1_3.queue_free()
	boss_room.sword_drop_1_4.queue_free()
	boss_room.sword_drop_2_1.queue_free()
	boss_room.sword_drop_2_2.queue_free()
	boss_room.sword_drop_2_3.queue_free()
	boss_room.sword_drop_2_4.queue_free()
	boss_room.sword_drop_3_1.queue_free()
	boss_room.sword_drop_3_2.queue_free()
	boss_room.sword_drop_3_3.queue_free()
	boss_room.sword_drop_3_4.queue_free()
	boss_room.sword_drop_4_1.queue_free()
	boss_room.sword_drop_4_2.queue_free()
	boss_room.sword_drop_4_3.queue_free()
	boss_room.sword_drop_4_4.queue_free()
	boss_room.devour_orb_spawn.queue_free()
	
	if is_instance_valid(meteor):
		meteor.queue_free()
	if is_instance_valid(boss_room.shadow_particle):
		boss_room.shadow_particle.queue_free()
	

func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)
	
func dash_animation_start():
	dash_particles.texture = sprite.texture
	dash_particles.emitting = true
	dash_trail.visible = true
	
func dash_animation_end():
	dash_particles.emitting = false
	dash_trail.visible = false
#func idle_toward_player() -> void:
	#var dir: Vector2 = (player.global_position - global_position).normalized()
	#
	#if abs(dir.x) > abs(dir.y):
		#if dir.x > 0:
			#animation_player.play("idle_right")
		#else:
			#animation_player.play("idle_left")
	#else:
		#if dir.y > 0:
			#animation_player.play("idle_down")
		#else:
			#animation_player.play("idle_up")
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
func orb_buff_vfx_off():
	pass
	
func apply_knockback():
	if player:
		player.apply_knockback(center_of_screen + Vector2(240, 135), -250) #350 #-125


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "walk":
		animation_player.play("idle")
	elif anim_name == "raise_hand":
		animation_player.play("charge")
	elif anim_name == "hand_down" or anim_name == "attack":
		animation_player.play("idle")
		
func beam_circle():
	circle_ref = beam_bar.instantiate()
	#owner.beam_circle_timer.start()
	circle_ref.position = to_local(player.global_position)
	add_child(circle_ref)
	
func spawn_attack():
	spawn_enrage_attack = enrage_attack.instantiate()
	get_parent().add_child(spawn_enrage_attack)
	
func protean_hit_vfx():
	spit_attack_white.play("default")
	spit_attack_red.play("default")
