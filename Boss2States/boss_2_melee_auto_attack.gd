extends State
#@onready var smoke: AnimatedSprite2D = $"../../smoke"
@onready var jump_slam: Area2D = $"../../JumpSlam"
#var LightningSlam = preload("res://Utilities/Effects/lightningvfx/MeleeSlamVFX.tscn")
@onready var dash_wind: AnimatedSprite2D = $"../../DashWindRotate/DashWind"
@onready var dash_wind_rotate: Marker2D = $"../../DashWindRotate"
@onready var jump_wind: AnimatedSprite2D = $"../../DashWindRotate/JumpWind"
@onready var jump_slam_telegraph: Sprite2D = $"../../JumpSlam/JumpSlamTelegraph"

var center_of_screen = get_viewport_rect().size / 2 
var attack_counter = 0
var store_player_position: Vector2
var can_transition: bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	#owner.attack_meter_animation.play("auto_attack")
	#animation_player.play("auto_attack")
	animation_player.play("charge_up_auto_attack")
	await animation_player.animation_finished
	
	animation_player.play("charge_auto_attack")
	await get_tree().create_timer(1.5).timeout
	
	owner.boss_2_main.melee_auto()
	dash_wind_rotate.rotation = dash_wind_rotate.global_position.angle_to_point(player.global_position)
	store_player_position = owner.player.position
	await get_tree().create_timer(0.6667).timeout
	if store_player_position.x - owner.position.x > 0:
		animation_player.play("auto_attack_right")
	else:
		animation_player.play("auto_attack_left")
	await get_tree().create_timer(0.0833).timeout
	move_boss_to_player(store_player_position, owner)
	
	
	
	await get_tree().create_timer(0.25).timeout
	#owner.slam_telegraph_player.play("slam_telegraph")
	#jump_slam_telegraph.global_position = player.global_position
	
	#await get_tree().create_timer(1).timeout
	
	#move_boss_to_player(store_player_position, owner)
	#await get_tree().create_timer(0.0667).timeout
	#
	#if store_player_position.x - owner.position.x > 0:
		#animation_player.play("auto_attack_right")
	#else:
		#animation_player.play("auto_attack_left")
	#await get_tree().create_timer(0.3333).timeout
	#lightning_slam()
	await get_tree().create_timer(1).timeout
	
	owner.auto_attack_count += 1
	can_transition = true
	
func move_boss_to_player(player_position: Vector2, boss: Node2D):
	#dash_wind.play("default")
	jump_wind.play("default")
	var move_boss = get_tree().create_tween()
	move_boss.tween_property(boss, "position", player_position, 0.25) #0.4 seconds before change
	
#func lightning_slam():
	#var lightning_slam = LightningSlam.instantiate()
	#print("global_position: ", owner.global_position)
	#lightning_slam.position = position
	##beam.position.angle_to_point(player.position)
	#add_child(lightning_slam)

func transition():
	if can_transition:
		can_transition = false
		if owner.auto_attack_count == 3:
			get_parent().change_state("Foretold")
		elif owner.auto_attack_count == 6:
			get_parent().change_state("WickedHeart")
		elif owner.auto_attack_count == 9:
			get_parent().change_state("Foretold")
		elif owner.auto_attack_count == 15:
			get_parent().change_state("Walk")
		else:
			enter()
		#elif attack_counter == 8:
			#get_parent().change_state("HandsOfPain")
