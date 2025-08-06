extends CharacterBody2D

signal boss_hit(boss_index)
var boss_index = -1
var is_correct_boss = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles

@onready var sac_pop_audio: AudioStreamPlayer2D = $sac_pop_audio
@onready var spawn_shadow_audio: AudioStreamPlayer2D = $SpawnShadowAudio

@onready var sac_particles: GPUParticles2D = $SacParticles
var boss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss.boss_died.connect(_on_boss_died)
	animation_player.play("sac_idle")
	spawn_shadow_audio.play()
	sac_particles.emitting = true
	
func _on_boss_died():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurtbox_area_entered(area: Area2D) -> void:
	emit_signal("boss_hit", boss_index)
	animation_player.play("sac_explode")
	sac_particles.emitting = false
	await animation_player.animation_finished
	queue_free()

func play_sac_explode():
	animation_player.play("sac_explode")
	sac_particles.emitting = false

func wrong_sac_explode():
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	aoe_particles.emitting = true
	
func sac_pop_sound():
	sac_pop_audio.play()
