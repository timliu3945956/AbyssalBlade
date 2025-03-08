extends State

var CircleAOE = preload("res://Characters/circle_aoe.tscn")
@onready var knockback_effect: AnimatedSprite2D = $"../../KnockbackEffect"
@onready var jump_effect: AnimatedSprite2D = $"../../JumpEffect"


var can_transition: bool = false
var center_of_screen = get_viewport_rect().size/2
var circle_count: int = 0

@onready var smoke: AnimatedSprite2D = $"../../smoke"

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	# Add Explosion mechanic here
	if owner.explosion_count == 0:
		owner.boss_room_animation.play("chargeup_explosions")
	else:
		owner.boss_room_animation.play("chargeup_explosions_2")
	
	animation_player.play("idle_right")
	await owner.boss_room_animation.animation_finished
	
	owner.smoke_1.play("smoke")
	owner.smoke_2.play("smoke")
	owner.smoke_3.play("smoke")
	owner.smoke_4.play("smoke")
	owner.smoke_5.play("smoke")
	owner.smoke_6.play("smoke")
	owner.smoke_7.play("smoke")
	owner.smoke_8.play("smoke")
	owner.smoke_9.play("smoke")
	owner.smoke_10.play("smoke")
	owner.smoke_11.play("smoke")
	owner.smoke_12.play("smoke")
	owner.smoke_13.play("smoke")
	owner.smoke_14.play("smoke")
	owner.smoke_15.play("smoke")
	owner.smoke_16.play("smoke")
	
	owner.boss_room_animation.play("sword_drop")
	if owner.explosion_count == 0:
		animation_player.play("idle_right")
	else:
		smoke.play("smoke")
		animation_player.play("teleport_out")
	await owner.boss_room_animation.animation_finished
		
	owner.boss_room_animation.play("explosions")
	await get_tree().create_timer(2.9988).timeout
	if owner.enraged:
		while circle_count < 7 and owner.boss_death == false:
			circle()
			circle_count += 1
			await get_tree().create_timer(2.9988).timeout
	else:
		await owner.boss_room_animation.animation_finished
	
	#await owner.boss_room_animation.animation_finished
	
	# Timing for jump slam ---------------------------------------
	#var jump_slam_length = animation_player.get_animation("jump_slam_knockback").length
	#animation_player.play("jump_slam_disappear")
	#await animation_player.animation_finished
	if owner.boss_death == false:
		boss.sprite.visible = true
		# Sync up with slam down animation
		#animation_player.play("jump_slam_knockback")
		#await get_tree().create_timer(0.8333).timeout
		#owner.in_out_animation_player.play("knockback_attack")
		#await animation_player.animation_finished
		
		
		#animation_player.play("jump_slam_reappear")
		#await animation_player.animation_finished
		
		if owner.explosion_count == 0:
			animation_player.play("jump_slam_knockback")
		else:
			smoke.play("smoke")
			animation_player.play("jump_slam_knockback_reappear")
		await get_tree().create_timer(1.5833).timeout
		jump_effect.play("jump_effect")
		await get_tree().create_timer(0.4167).timeout
		knockback_effect.play("knockback_effect")
		await get_tree().create_timer(0.25).timeout
		
		#meteor here
		await get_tree().create_timer(1).timeout
		animation_player.play("idle_right")
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
		#owner.in_out_animation_player.play("knockback_attack")
		#await animation_player.animation_finished
		
		# ENRAGE MODE
		if !owner.enraged:
			#await get_tree().create_timer(1).timeout
			#animation_player.play("idle_right")
			#player.beam_circle_meteor()
			#owner.boss_room_animation.play("meteor")
			#await get_tree().create_timer(2.6668).timeout
			#animation_player.play("alternate_slam")
			#await get_tree().create_timer(0.3332).timeout
			#owner.beam_circle()
			#
			#owner.meteor.closest_square_position(player.position)
			#await get_tree().create_timer(1.4004).timeout
			#animation_player.play("idle_right")
			#await get_tree().create_timer(0.9996).timeout
			
			#Phase 2 cast here
			animation_player.play("idle_right")
			owner.boss_room_animation.play("enrage_cast")
			await owner.boss_room_animation.animation_finished
			animation_player.play("mini_enrage")
			await get_tree().create_timer(0.4).timeout
			owner.camera_shake_phase_2()
			owner.enrage_background.play("background_change")
			owner.enrage_fire.emitting = true
			owner.enrage_fire.visible = true
			owner.enrage_fire_pop.emitting = true
			owner.enraged = true
			await get_tree().create_timer(0.5).timeout
			animation_player.play("idle_right")
		
		#await owner.boss_room_animation.animation_finished
		#await get_tree().create_timer(1).timeout
		#animation_player.play("idle_right")
		#player.beam_circle_meteor()
		#owner.boss_room_animation.play("meteor")
		#await get_tree().create_timer(2.6668).timeout
		#animation_player.play("alternate_slam")
		#await get_tree().create_timer(0.3332).timeout
		#owner.beam_circle()
		#
		#owner.meteor.closest_square_position(player.position)
		#await get_tree().create_timer(1.4004).timeout
		#animation_player.play("idle_right")
		#await get_tree().create_timer(0.9996).timeout
		owner.explosion_count += 1
		can_transition = true
	
func circle():
	var circleAOE = CircleAOE.instantiate()
	circleAOE.position = player.position
	add_child(circleAOE)
	
func disappear():
	var fade_duration = 100
	var fade_step = 1.0 / fade_duration
	owner.sprite.modulate.a = max(0, owner.sprite.modulate.a - fade_step)
	
func reappear():
	var fade_duration = 100
	var fade_step = 1.0 / fade_duration
	owner.sprite.modulate.a = min(1, owner.sprite.modulate.a + fade_step)
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
