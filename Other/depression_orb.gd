extends CharacterBody2D

@onready var orb_color_change_timer: Timer = $OrbColorChangeTimer
@onready var orb_explode_timer: Timer = $OrbExplodeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_animation: AnimatedSprite2D = $ExplodeVFX/ExplodeAnimation
@onready var fire_orb_explode: AnimatedSprite2D = $FireOrbExplode
@onready var gold_orb_explode: AnimatedSprite2D = $GoldOrbExplode
@onready var gold_orb_collect: AnimatedSprite2D = $GoldOrbCollect
@onready var sac_aoe_1: AnimatedSprite2D = $SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $SacAOE2
@onready var aoe_particles: GPUParticles2D = $AOEParticles

#vfx
@onready var fire_orb_red: AnimatedSprite2D = $"FireOrb(Red)"
@onready var gold_orb: AnimatedSprite2D = $"GoldOrb(Gold)"

@onready var orb_zero_velocity_timer: Timer = $OrbZeroVelocityTimer

var move_speed = 21.25
var current_speed: float
var orb_color: String = "red"
var player: CharacterBody2D

func _ready():
	#orb_color_change_timer.start()
	orb_explode_timer.start()
	animation_player.play("orb_red_start")
	fire_orb_red.play("default")
	gold_orb.play("default")
	orb_zero_velocity_timer.start()
	
func explode_vfx(): #orb explode vfx here
	pass
	
func _physics_process(delta: float) -> void:
	if orb_zero_velocity_timer.time_left > 0:
		velocity = Vector2.ZERO
		current_speed = 0.0
	else:
		current_speed = min(current_speed + (move_speed * delta), move_speed)
		velocity = (player.position - position).normalized() * current_speed
	position += velocity * delta

func _on_orb_hitbox_area_entered(area: Area2D) -> void:
	if orb_color == "red":
		animation_player.play("orb_explode")
		fire_orb_red.visible = false
		randomize()
		fire_orb_explode.rotation_degrees = randi_range(0, 360)
		fire_orb_explode.play("default")
		await animation_player.animation_finished
	else:
		#play animation here for gold absorb
		gold_orb.visible = false
		set_physics_process(false)
		randomize()
		gold_orb_collect.rotation_degrees = randi_range(0, 360)
		gold_orb_collect.play("default")
		GlobalEvents.emit_signal("orb_collected")
		await gold_orb_collect.animation_finished
	queue_free()

#if orb reaches 10 seconds and doesnt get absorbed
func _on_orb_explode_timer_timeout() -> void:
	gold_orb.visible = false
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	aoe_particles.emitting = true
	gold_orb_explode.play("default")
	animation_player.play("orb_explode")
	await animation_player.animation_finished
	queue_free()


func _on_orb_color_change_timer_timeout() -> void:
	if orb_color == "red":
		animation_player.play("red_to_gold")
		orb_color = "gold"
		
