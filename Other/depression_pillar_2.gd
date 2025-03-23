extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pillar_timer: Timer = $PillarTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var black_wind: AnimatedSprite2D = $BlackWind

@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles

@onready var flash_timer: Timer = $FlashTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var slash_particles: CPUParticles2D = $Marker2D/SlashParticles
@onready var slash_glow: CPUParticles2D = $Marker2D/SlashGlow
@onready var sword_particles: CPUParticles2D = $Marker2D/SwordParticles
@onready var hit_particles: AnimatedSprite2D = $HitParticles2
@onready var label: Label = $Label
@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio

@onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D

var invincible: bool = true
var player: CharacterBody2D #variable given in boss state machine
var timer_set: float 
var collision_set: bool

func _ready():
	black_wind.play("default")
	var tween = get_tree().create_tween()
	tween.tween_property(sprite.material, "shader_parameter/fade_alpha", 1, 0.5)
	tween.tween_property(sprite_shadow.material, "shader_parameter/fade_alpha", 1, 0.5)
	animation_player.play("pillar_idle")
	spawn_shadow_audio.play()
	pillar_timer.start(timer_set)
	hurtbox.disabled = collision_set
	
func _process(delta):
	if pillar_timer.time_left > 0:
		label.text = str(int(pillar_timer.time_left))

#Hitbox for DEPRESSIVE THOUGHTS
func _on_hurtbox_area_entered(area: Area2D) -> void:
	
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
	if player.transformed:
		player.abyssal_surge_hit.play()
	else:
		player.hit.play()
	
	#checks if player orb buff is on
	if player.orb_buff == true:
		player.orb_buff = false
		label.queue_free()
		pillar_timer.stop()
		player.orb_buff_vfx_off()
		animation_player.play("pillar_break")
		await get_tree().create_timer(1).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(sprite.material, "shader_parameter/fade_alpha", 0, 0.5)
		tween.tween_property(sprite_shadow.material, "shader_parameter/fade_alpha", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
# hurtbox for DESTRUCTIVE THOUGHTS
func _on_hurtbox_for_boss_area_entered(area: Area2D) -> void:
	print("pillar hit by boss protean")
	if is_instance_valid(label):
		label.queue_free()
	flash()
	#label.queue_free()
	pillar_timer.stop()
	animation_player.play("pillar_break")
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(sprite.material, "shader_parameter/fade_alpha", 0, 0.5)
	tween.tween_property(sprite_shadow.material, "shader_parameter/fade_alpha", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	
	queue_free()

func _on_pillar_timer_timeout() -> void:
	if is_instance_valid(label):
		label.queue_free()
	animation_player.play("pillar_explode")
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	aoe_particles.emitting = true
	await animation_player.animation_finished
	queue_free()


func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void: 
	sprite.material.set_shader_parameter("flash_modifier", 0)
