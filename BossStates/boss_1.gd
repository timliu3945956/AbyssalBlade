extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var meteor = get_parent().find_child("MeteorDrops")

@onready var collision: CollisionShape2D = $SlashHitBox/CollisionShape2D
#@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var timer: Timer = $SlashHitBox/Timer
@onready var timer_2: Timer = $SlashHitBox/Timer2
@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D

@onready var chain_attack_collision_timer: Timer = $ChainAim/ChainAttackCollisionTimer
@onready var chain_attack_collision_off_timer: Timer = $ChainAim/ChainAttackCollisionOffTimer
@onready var chain_attack_follow_timer: Timer = $ChainAim/ChainAttackFollowTimer
@onready var collision_shape_2d: CollisionShape2D = $ChainAim/ChainHitBox/CollisionShape2D

@onready var enrage_fire: GPUParticles2D = $EnrageFire
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop

@onready var alternate_smoke: AnimatedSprite2D = $AlternateSmoke

@onready var attack_meter: Node2D = $AttackMeter

@onready var animation_player = $AnimationPlayer
@onready var eruption_player = $EruptionPlayer

@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var in_out_animation_player: AnimationPlayer = get_node("../InOutAnimationPlayer")
@onready var top_bottom_animation_player: AnimationPlayer = get_node("../TopBottomAnimationPlayer")
@onready var light_animation_player: AnimationPlayer = get_node("../LightAnimationPlayer")
@onready var boss_killed = get_node("../BossKilled")
@onready var enrage_background: AnimationPlayer = get_node("../EnrageBackground")
@onready var boss_death: bool = false

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

@onready var smoke_alternate_1: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeAlternate1")
@onready var smoke_alternate_2: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeAlternate2")
@onready var smoke_alternate_opposite_1: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeAlternateOpposite1")
@onready var smoke_alternate_opposite_2: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeAlternateOpposite2")

@onready var smoke_top_1: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeTop1")
@onready var smoke_top_2: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeTop2")
@onready var smoke_bottom_1: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeBottom1")
@onready var smoke_bottom_2: AnimatedSprite2D = get_parent().get_node("InOutAttack/SmokeBottom2")

@onready var attack_fire: AnimatedSprite2D = $NormalAttack/AttackFire
@onready var normal_attack: Sprite2D = $NormalAttack

@onready var chain_aim: Marker2D = $ChainAim

# audio
@onready var slash_audio: AudioStreamPlayer2D = $SlashAudio
#@onready var knockback_slam_audio: AudioStreamPlayer2D = $KnockbackSlamAudio
@onready var sword_appear_audio: AudioStreamPlayer2D = $SwordAppearAudio
@onready var sword_disappear_audio: AudioStreamPlayer2D = $SwordDisappearAudio
@onready var knockback_slam_audio: AudioStreamPlayer2D = $KnockbackAudio
@onready var chain_slash_audio: AudioStreamPlayer2D = $ChainSlashAudio
@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

# flash particles
@onready var sprite = $Sprite2D
@onready var flash_timer: Timer = $flashTimer
@onready var hit_particles: CPUParticles2D = $HitParticles
@onready var hit_particles_2: AnimatedSprite2D = $HitParticles2


@onready var marker_2d: Marker2D = $Marker2D
@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow

@onready var healthbar = $CanvasLayer/Healthbar
var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_fade.tscn")
var circle_ref: Node2D
var enraged: bool = false

var direction : Vector2
var move_speed = 120
var slash_count: int = 0
var explosion_count: int = 0
var top_down_charge_count: int = 0

# Change healthbar value as well to change healthbar health: 37500
var health_amount = 75000 : set = _set_health
var center_of_screen = get_viewport_rect().size / 2 

var choose_top_down = randi_range(1, 2)
var timeline: int = 0

func _ready():
	set_physics_process(false)
	healthbar.init_health(health_amount)
	GlobalCount.can_pause = true
	#player.charge_icon_disable()
	attack_fire.visible = false
	normal_attack.visible = false
	hit_particles_2.frame = 0
	alternate_smoke.modulate.a = 0
	alternate_smoke.play("new_animation_1")

func _process(_delta):
	if chain_attack_follow_timer.time_left > 0:
		chain_aim.rotation = chain_aim.global_position.angle_to_point(player.global_position)
		
	match timeline:
		0:
			# Two Pounds
			direction = player.position - position
		1:
			# Mechanic 1 In/Out Attack (stands in place where they are)
			direction = Vector2.ZERO
		2:
			# Two Pounds
			direction = player.position - position
		3:
			# Knockback In Out
			direction = center_of_screen - position
		4:
			# Two Pounds
			direction = player.position - position
		5:
			# Alternating Qudrants + baited circles AOE (Oscillating Fury)
			direction = center_of_screen - position
		6:
			# two slashes + top/bottom hit
			direction = player.position - position
		7:
			direction = Vector2.ZERO
		8:
			# Two Pounds (immediately after mini-enrage)
			direction = player.position - position
		9:
			# Wave of Hatred
			direction = center_of_screen - position
		10:
			# Two Pounds
			direction = player.position - position
		11:
			# Combination Fury
			direction = center_of_screen - position
		12:
			# Two Pounds
			direction = player.position - position
		13:
			# Wave of Hatred
			direction = center_of_screen - position
		14:
			# Two Pounds
			direction = player.position - position
		15:
			# Enrage
			direction = center_of_screen - position
		16:
			direction = player.position - position
		17:
			direction = center_of_screen - position
		#16:
			## Enrage (20 seconds)
			#direction = center_of_screen - position

func _physics_process(_delta):
	velocity = direction.normalized() * move_speed
	move_and_slide()

func _set_health(value):
	health_amount = value
	healthbar.health = health_amount
	
func _on_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
	attack_fire.visible = true
	timer_2.start()
	
func _on_timer_2_timeout() -> void:
	collision.call_deferred("set", "disabled", true)
	
func _on_chain_attack_collision_timer_timeout() -> void:
	collision_shape_2d.call_deferred("set", "disabled", false)
	chain_attack_collision_off_timer.start()

func _on_chain_attack_collision_off_timer_timeout() -> void:
	collision_shape_2d.call_deferred("set", "disabled", true)

func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)
	
func slashing_audio():
	slash_audio.play()
	
func knockback_audio():
	knockback_slam_audio.play()
	
func sword_appearing_audio():
	sword_appear_audio.play()

func sword_disappearing_audio():
	sword_disappear_audio.play()
	
func chain_slashing_audio():
	chain_slash_audio.play()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	GlobalCount.healthbar.apply_shake(1, 10.0)
	if area.name == "HitBox":
		health_amount -= player.damage_amount
		GlobalCount.dps_count += player.damage_amount
		flash()
		hit_particles_2.rotation = position.angle_to_point(player.position) + PI + 45
		#hit_particles.rotation = position.angle_to_point(player.position) + PI
		marker_2d.rotation = position.angle_to_point(player.position) + PI
		
		sword_particles.emitting = true
		slash_particles.emitting = true
		slash_glow.emitting = true
		#hit_particles.emitting = true
		hit_particles_2.play("hit_particles")
		
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
		
		hit_particles_2.rotation = position.angle_to_point(player.position) + PI + 45
		#hit_particles.rotation = position.angle_to_point(player.position) + PI
		marker_2d.rotation = position.angle_to_point(player.position) + PI
		
		sword_particles.emitting = true
		slash_particles.emitting = true
		slash_glow.emitting = true
		#hit_particles.emitting = true
		hit_particles_2.play("hit_particles")
		
		if player.swing.playing:
			player.swing.stop()
		
		player.heavy_hit.play()
		
		if player.mana < 20:
			player.mana += 4 #4
			if player.mana >= 20:
				player.surge_ready.play()
				player.transform_icon_disable()
				player.charge_icon_disable()
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
		
	if health_amount <= 0:
		player.hurtbox_slash_collision.call_deferred("set", "disabled", true)
		player.hurtbox_collision.call_deferred("set", "disabled", true)
		
		hurtbox.call_deferred("set", "disabled", true)
		
		boss_room_animation.queue_free()
		top_bottom_animation_player.queue_free()
		in_out_animation_player.queue_free()
		animation_player.stop()
		
		attack_meter.queue_free()
		boss_death = true
		find_child("FiniteStateMachine").change_state("Death")

func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)

func camera_shake_phase_2():
	GlobalCount.camera.apply_shake(5, 25.0)
	
func beam_circle():
	circle_ref = beam_bar.instantiate()
	#owner.beam_circle_timer.start()
	circle_ref.position = to_local(player.global_position)
	add_child(circle_ref)
