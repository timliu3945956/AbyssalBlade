extends CharacterBody2D

@onready var orb_color_change_timer: Timer = $OrbColorChangeTimer
@onready var orb_explode_timer: Timer = $OrbExplodeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_animation: AnimatedSprite2D = $ExplodeVFX/ExplodeAnimation
@onready var gold_orb_explode: AnimatedSprite2D = $GoldOrbExplode
@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles

#vfx
@onready var fire_orb_red: AnimatedSprite2D = $"FireOrb(Red)"
@onready var gold_orb_collect: AnimatedSprite2D = $GoldOrbCollect

var boss: CharacterBody2D
var tween: Tween

func _ready():
	#orb_color_change_timer.start()
	#animation_player.play("orb_red_start")
	fire_orb_red.play("default")
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", boss.position, 5)

func _on_orb_hitbox_area_entered(area: Area2D) -> void:
	animation_player.play("orb_explode")
	gold_orb_explode.play("default")
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	aoe_particles.emitting = true
	await animation_player.animation_finished
	#insert anim for orb exploding
	queue_free()

func _on_orb_player_hurtbox_area_entered(area: Area2D) -> void:
	GlobalEvents.emit_signal("devour_gold_collected")
	#insert anim for orb dissapearing here
	fire_orb_red.visible = false
	tween.kill()
	randomize()
	gold_orb_collect.rotation_degrees = randi_range(0, 360)
	gold_orb_collect.play("default")
	await gold_orb_collect.animation_finished
	queue_free()
