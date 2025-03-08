extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var jump_slam: Area2D = $"../../JumpSlam"

var center_of_screen = get_viewport_rect().size / 2 
var attack_counter = 0
var store_player_position: Vector2
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.attack_meter_animation.play("auto_attack")
	#animation_player.play("auto_attack")
	animation_player.play("charge_up_auto_attack")
	await animation_player.animation_finished
	animation_player.play("charge_auto_attack")
	
	await get_tree().create_timer(1.6667).timeout

	play_and_move_boss_to_player()	
	
	play_and_move_boss_to_player()	
	
	play_and_move_boss_to_player()	

	#animation_player.play("jump_away")
	#await animation_player.animation_finished
	#animation_player.play("jump_land")
	#await animation_player.animation_finished
	
	attack_counter += 1
	can_transition = true

func play_and_move_boss_to_player():
	owner.slam_telegraph_player.play("slam_telegraph")
	jump_slam.global_position = player.global_position
	store_player_position = owner.player.position
	await get_tree().create_timer(1).timeout

	var move_boss = get_tree().create_tween()
	move_boss.tween_property(owner, "position", store_player_position, 0.4)

	await get_tree().create_timer(0.3167).timeout
	animation_player.play("auto_attack")
	await get_tree().create_timer(0.6833).timeout

func transition():
	if can_transition:
		can_transition = false
		if attack_counter == 9:
			get_parent().change_state("HandsOfDeath")
		elif attack_counter == 6:
			get_parent().change_state("HandsOfPain")
		elif attack_counter == 3:
			get_parent().change_state("HandsOfPain")
		else:
			enter()
