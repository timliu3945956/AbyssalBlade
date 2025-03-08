extends State

@onready var knockback_effect: AnimatedSprite2D = $"../../KnockbackEffect"
@onready var jump_effect: AnimatedSprite2D = $"../../JumpEffect"

var can_transition: bool = false
#var camera = get_viewport().get_camera_2d()
var center_of_screen = get_viewport_rect().size/2

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	# Timing for jump slam ---------------------------------------
	var jump_slam_length = animation_player.get_animation("jump_slam_knockback").length
	
	#owner.light_animation_player.play("knockback_indicator")
	#await get_tree().create_timer(1).timeout
	
	animation_player.play("jump_slam_knockback")
	await get_tree().create_timer(1.5833).timeout
	jump_effect.play("jump_effect")
	await get_tree().create_timer(0.4167).timeout
	knockback_effect.play("knockback_effect")
	#await get_tree().create_timer(0.25).timeout
	#owner.in_out_animation_player.play("knockback_attack")
	#await owner.in_out_animation_player.animation_finished
	await get_tree().create_timer(0.3333).timeout
	animation_player.play("idle_right")
	await get_tree().create_timer(0.6667).timeout
	#animation_player.play("idle_right")
	player.beam_circle_meteor()
	owner.boss_room_animation.play("meteor")
	await get_tree().create_timer(2.6668).timeout
	animation_player.play("alternate_slam")
	await get_tree().create_timer(0.3332).timeout
	owner.beam_circle()
	
	owner.meteor.closest_square_position(player.position)
	await get_tree().create_timer(1.4004).timeout
	animation_player.play("idle_right")
	await get_tree().create_timer(0.9996).timeout
	
	
	#animation_player.play("jump_slam_disappear")
	#await animation_player.animation_finished
	
	
	#await get_tree().create_timer(0.75).timeout
	#owner.eruption_player.play("eruption")
	
	#await get_tree().create_timer(1).timeout
	
	# Sync up with slam down animation
	
	
	
	#await get_tree().create_timer(jump_slam_length - 0.7497).timeout
	#if player:
		#player.apply_knockback(center_of_screen + Vector2(240, 135), 550)
	
	#await animation_player.animation_finished
	#await animation_player.animation_finished
	
	#await get_tree().create_timer(1).timeout
	#animation_player.play("jump_slam_reappear")
	#owner.boss_room_animation.play("attack_out_fast")
	
	
	
	# In Out attack here --------------------------------------
	#var choose_in_out = randi_range(1, 2)
	#match choose_in_out:
		#1:
			#owner.boss_room_animation.play("attack_in")
		#2:
			#owner.boss_room_animation.play("attack_out")
	#var charge_into_animation_length = animation_player.get_animation("charge_into").length
	#var charge_outof_animation_length = animation_player.get_animation("charge_outof").length
	#var animation_length = owner.boss_room_animation.get_animation("attack_out_").length
	
	#var charge_into_animation_length = animation_player.get_animation("charge_into").length
	#var charge_outof_animation_length = animation_player.get_animation("charge_outof").length
	#var animation_length = owner.boss_room_animation.get_animation("attack_out_fast").length
	#
	#animation_player.play("charge_into")
	#await animation_player.animation_finished
#
	#animation_player.play("charge")
	#await get_tree().create_timer(animation_length-charge_into_animation_length-charge_outof_animation_length).timeout
#
	#animation_player.play("charge_outof")
	#await animation_player.animation_finished
	#await owner.boss_room_animation.animation_finished
	can_transition = true
	
func apply_knockback():
	if player:
		player.apply_knockback(center_of_screen + Vector2(240, 135), 350) #400) #400
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 2 #1
		get_parent().change_state("AlternateAttack") #Transition
