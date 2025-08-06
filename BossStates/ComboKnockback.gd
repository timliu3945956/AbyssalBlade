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
	#var jump_slam_length = animation_player.get_animation("jump_slam_knockback").length
	
	var jump_slam_length = animation_player.get_animation("jump_slam_knockback").length
		
	animation_player.play("jump_slam_knockback")
	await TimeWait.wait_sec(1.5833)#await get_tree().create_timer(1.5833).timeout
	jump_effect.play("jump_effect")
	await TimeWait.wait_sec(0.4167)#await get_tree().create_timer(0.4167).timeout
	knockback_effect.play("knockback_effect")
	
	await TimeWait.wait_sec(0.3333)#await get_tree().create_timer(0.3333).timeout
	animation_player.play("idle_right")
	await TimeWait.wait_sec(0.6667)#await get_tree().create_timer(0.6667).timeout
	owner.boss_room_animation.play("meteor")
	await TimeWait.wait_sec(2.6668)#await get_tree().create_timer(2.6668).timeout
	animation_player.play("alternate_slam")
	await TimeWait.wait_sec(0.3332)#await get_tree().create_timer(0.3332).timeout
	
	owner.meteor.closest_square_position(player.position)
	await TimeWait.wait_sec(1.4004)#await get_tree().create_timer(1.4004).timeout
	animation_player.play("idle_right")
	await TimeWait.wait_sec(0.9996)#await get_tree().create_timer(0.9996).timeout
		
	can_transition = true
	
func apply_knockback():
	if player:
		player.apply_knockback(center_of_screen + Vector2(240, 135), 350) #350
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 2 #1
		get_parent().change_state("Explosions") #Transition
