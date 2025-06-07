extends CharacterBody2D

@onready var orb_color_change_timer: Timer = $OrbColorChangeTimer
@onready var orb_explode_timer: Timer = $OrbExplodeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_animation: AnimatedSprite2D = $ExplodeVFX/ExplodeAnimation
@onready var fire_orb_collect: AnimatedSprite2D = $FireOrbCollect
@onready var fire_orb_explode: AnimatedSprite2D = $FireOrbExplode
@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles
@onready var orb_soak_audio: AudioStreamPlayer2D = $OrbSoakAudio
@onready var collision_shape_2d: CollisionShape2D = $OrbPlayerHurtbox/CollisionShape2D

#vfx
@onready var fire_orb_red: AnimatedSprite2D = $"FireOrb(Red)"
var boss: CharacterBody2D
var tween: Tween

func _ready():
	#orb_color_change_timer.start()
	animation_player.play("orb_red_start")
	fire_orb_red.play("default")
	if boss.devour_meter.modulate.a == 0:
		var tween_bar = get_tree().create_tween()
		tween_bar.tween_property(boss.devour_meter, "modulate:a", 1, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", boss.position, 3)
	collision_shape_2d.disabled = false
	
func _on_orb_hitbox_area_entered(area: Area2D) -> void:
	#animation_player.play("orb_explode")
	#fire_orb_explode.play("default")
	#sac_aoe_1.play("default")
	#sac_aoe_2.play("default")
	#aoe_particles.emitting = true
	#await animation_player.animation_finished
	collision_shape_2d.set_deferred("disabled", true)
	boss.devour_bar.value += 12.5
		
	orb_soak_audio.play()
	fire_orb_red.visible = false
	tween.kill()
	randomize()
	fire_orb_collect.rotation_degrees = randi_range(0, 360)
	fire_orb_collect.play("default")
	
	
	if boss.devour_bar.value >= 100:
		boss.symbol_change_audio.play()
		var tween = get_tree().create_tween()
		tween.tween_property(boss.devour_meter, "modulate:a", 0, 0.5)
		boss.devour_meter_player.play("expand_meter")
		boss.orb_buff_vfx_off()
		if boss.name == "Boss4Final":
			boss.animation_player.play("attack")
		else:
			boss.animation_player.play("barrage")
		await get_tree().create_timer(0.5).timeout
		boss.knockback_audio.play()
		camera_shake()
		boss.knockback_effect.play_backwards("default")
		boss.apply_knockback()
		
		boss.devour_bar.value = 0
	await fire_orb_collect.animation_finished
	queue_free()

func _on_orb_player_hurtbox_area_entered(area: Area2D) -> void:
	GlobalEvents.emit_signal("devour_red_collected")
	orb_soak_audio.play()
	fire_orb_red.visible = false
	if is_instance_valid(self):
		tween.kill()
	randomize()
	fire_orb_collect.rotation_degrees = randi_range(0, 360)
	fire_orb_collect.play("default")
	await fire_orb_collect.animation_finished
	
	queue_free()
	
func camera_shake():
	GlobalCount.camera.apply_shake(5, 25.0)
