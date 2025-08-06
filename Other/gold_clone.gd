extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var enrage_fire_pop: GPUParticles2D = $EnrageFirePop
@onready var spawn_clone_audio: AudioStreamPlayer2D = $SpawnCloneAudio
@onready var gold_particles: GPUParticles2D = $GoldParticles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var flash_timer: Timer = $FlashTimer
@onready var glass_shatter_audio: AudioStreamPlayer2D = $GlassShatterAudio
@onready var sprite_shadow: Sprite2D = $SpriteShadow

var player: CharacterBody2D
var boss: CharacterBody2D

func _ready() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)
	gold_particles.emitting = true
	spawn_clone_audio.play()
	enrage_fire_pop.emitting = true
	print("spawned clone")
	boss.connect("gold_clone_aoe", Callable(self, "_on_gold_clone_hit"))
	global_position = player.global_position
	

func _process(delta: float) -> void:
	pass
	
func flash():
		sprite.material.set_shader_parameter("flash_modifier", 1)
		flash_timer.start()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	collision.call_deferred("set", "disabled", true)
	gold_particles.emitting = false
	#animation_player.play("fail")
	flash()
	await get_tree().create_timer(0.2).timeout
	glass_shatter_audio.play()
	sprite.visible = false
	sprite_shadow.visible = false
	animated_sprite_2d.play("default")
	#await animation_player.animation_finished
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_gold_clone_hit():
	gold_particles.emitting = false
	enrage_fire_pop.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0, 1)
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)
