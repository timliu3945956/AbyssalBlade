extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var chain_tiles_audio: AudioStreamPlayer2D = $"../../ChainTilesAudio"

var center_of_screen = get_viewport_rect().size / 2 

var can_transition: bool = false
const HIT_DURATION = 0.6
var first_triangle_check: int

var triangle_centers = [
	Vector2(-100, 0),
	Vector2(100, 0)
]


signal attack_done

func enter():
	super.enter()
	owner.set_physics_process(true)
	if owner.center_of_screen.x - owner.position.x > 0:
		animation_player.play("idle_right")
	else:
		animation_player.play("idle_left")
	
	owner.attack_meter_animation.play("chain_destruction")
	await owner.attack_meter_animation.animation_finished
	
	
	animation_player.play("jump")
	await animation_player.animation_finished
	owner.boss_attack_animation.play("chain_impact_combo")
	await get_tree().create_timer(2.8333).timeout
	owner.position = owner.center_of_screen + Vector2(100, 0)
	if owner.center_of_screen.x - owner.position.x > 0:
		owner.sprite.flip_h = false
	else:
		owner.sprite.flip_h = true
	animation_player.play("slamdown")
	owner.sword_animation.play("sword_drop_chain")
	#await animation_player.animation_finished
	#owner.boss_attack_animation.play("chain_impact_combo")
	#await get_tree().create_timer(2.75).timeout
	#animation_player.play("jump")
	#await get_tree().create_timer(0.6667).timeout
	#owner.sword_animation.play("sword_drop_chain")
	#await get_tree().create_timer(0.0833).timeout
	#owner.position = owner.center_of_screen + Vector2(100, 0)
	#await get_tree().create_timer(0.0833).timeout
	#if owner.center_of_screen.x - owner.position.x > 0:
		#owner.sprite.flip_h = false
	#else:
		#owner.sprite.flip_h = true
	#
	#animation_player.play("slamdown")
	
	
	await animation_player.animation_finished
	owner.sword_animation.play("sword_drop_chain_end")
	await get_tree().create_timer(1).timeout
	
	if owner.center_of_screen.x - owner.position.x > 0:
		owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_dashfinish.png")
	else:
		owner.dash_particles.texture = preload("res://sprites/BargainingBoss/MainBoss/newest animation/Main/bargain_dashfinish_flipped.png")
		
	owner.dash_particles.material.set_shader_parameter("particles_anim_h_frames", 3)
	owner.dash_particles.emitting = true
	var move_position = owner.center_of_screen
	var tween = get_tree().create_tween()
	tween.tween_property(owner, "position", move_position, 0.5)
	animation_player.play("dash_stop")
	owner.dash_audio.play()
	owner.jump_audio.play()
	await get_tree().create_timer(0.5).timeout
	owner.dash_particles.emitting = false
	
	
	
	
	
	
	owner.attack_meter_animation.play("malice")
	animation_player.play("idle_right")
	await get_tree().create_timer(2.25).timeout
	animation_player.play("buff")
	await owner.attack_meter_animation.animation_finished
	await get_tree().create_timer(0.1667).timeout
	owner.boss_attack_animation_2.play("malice_reverse")
	animation_player.play("idle_right")
	await get_tree().create_timer(1.5).timeout #instead of 2, 1.5 seconds await
	
	if owner.boss_death == false:
		can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Beam")
 
