extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var follow_timer: Timer = $FollowTimer
@onready var top_bottom_attack_2: AnimatedSprite2D = $VFX/TopBottomAttack2
@onready var top_bottom_attack_3: AnimatedSprite2D = $VFX/TopBottomAttack3
@onready var animated_sprite_2d: AnimatedSprite2D = $VFX/AnimatedSprite2D
@onready var animated_sprite_2d_3: AnimatedSprite2D = $VFX/AnimatedSprite2D3
@onready var animated_sprite_2d_2: AnimatedSprite2D = $VFX/AnimatedSprite2D2
@onready var animated_sprite_2d_4: AnimatedSprite2D = $VFX/AnimatedSprite2D4

var player: CharacterBody2D
var boss: CharacterBody2D

func _ready():
	global_position = player.global_position
	animation_player.play("telegraph")
	follow_timer.start()
	await animation_player.animation_finished
	animation_player.play("attack")
	play_vfx()
	
func _process(delta):
	if follow_timer.time_left > 0:
		global_position = player.global_position
		#rotation = global_position.angle_to_point(boss.global_position)
		#
func play_vfx():
	#animated_sprite_2d.play("default")
	#animated_sprite_2d_2.play("default")
	#animated_sprite_2d_3.play("default")
	#animated_sprite_2d_4.play("default")
	#animated_sprite_2d_5.play("default")
	#animated_sprite_2d_6.play("default")
	#animated_sprite_2d_7.play("default")
	#animated_sprite_2d_8.play("default")
	top_bottom_attack_2.play("default")
	top_bottom_attack_3.play("default")
	animated_sprite_2d.play("default")
	animated_sprite_2d_3.play("default")
	animated_sprite_2d_2.play("default")
	animated_sprite_2d_4.play("default")
