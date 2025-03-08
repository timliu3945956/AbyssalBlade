extends CharacterBody2D

@export var move_speed = 150
@export var health_amount : int = 100

var player = null
var movement_direction = Vector2.ZERO

var is_player_in_slash_range = false
var is_slashing = false
var slash_count = 0
var center_of_screen = get_viewport_rect().size / 2
var is_in_out_attack_active = false
var in_out_count = 0

var current_phase: int = 0
#velocity = Vector2.ZERO

#Define boss states
enum BossState {
	IDLE,
	CHASING,
	SLASHING,
	MOVING_TO_CENTER,
	IN_OUT_ATTACK,
	ALT_QUADRANTS_ATTACK
}

var current_state: BossState = BossState.IDLE

@onready var animation_player = $AnimationPlayer
@onready var boss_room_animation = get_node("../BossRoomAnimationPlayer")
@onready var collision: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var timer: Timer = $SlashHitBox/Timer
@onready var timer_2: Timer = $SlashHitBox/Timer2

@onready var circle_aoe: Area2D = $CircleAOE
#@onready var circle_aoe_animation = get_node("CircleAOEAnimationPlayer")
@onready var circle_aoe_animation: AnimationPlayer = $CircleAOE/CircleAOEAnimationPlayer


# Effects for getting hit
@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $flashTimer
@onready var hit_particles: CPUParticles2D = $HitParticles



func _ready():
	player = get_parent().get_node("Player")
	collision.call_deferred("set", "disabled", true)
func _physics_process(_delta):
	match current_state:
		BossState.IDLE:
			handle_idle_state()
		BossState.CHASING:
			handle_chasing_state()
		BossState.SLASHING:
			handle_slashing_state()
		BossState.MOVING_TO_CENTER:
			handle_moving_to_center_state()
		BossState.IN_OUT_ATTACK:
			handle_in_out_attack_state()
		BossState.ALT_QUADRANTS_ATTACK:
			handle_alt_quadrants_attack_state()
	#print(current_state)

	update_animation()
	move_and_slide()
	

func handle_idle_state():
	stop_movement()
	if is_player_in_slash_range:
		current_state = BossState.SLASHING
	elif player != null:
		current_state = BossState.CHASING

func handle_chasing_state():
	if player != null:
		move_towards(player.position)
		#print("moving towards player")
		if is_player_in_slash_range:
			current_state = BossState.SLASHING
		elif slash_count >= 3:
			current_state = BossState.MOVING_TO_CENTER
	else:
		current_state = BossState.IDLE

func handle_slashing_state():
	if not is_slashing:
		slash()
	elif slash_count >= 3:
		current_state = BossState.MOVING_TO_CENTER
	elif not is_player_in_slash_range:
		current_state = BossState.CHASING
	else:
		current_state = BossState.IDLE

func handle_moving_to_center_state():
	move_towards(center_of_screen)
	if (center_of_screen - position).length() <= 2:
		stop_movement()
		if current_phase == 0:
			current_state = BossState.IN_OUT_ATTACK
		elif current_phase == 1:
			current_state = BossState.ALT_QUADRANTS_ATTACK
		else:
			current_state = BossState.IDLE

func handle_in_out_attack_state():
	if not is_in_out_attack_active:
		inOutAttack()
	elif not is_in_out_attack_active:
		slash_count = 0
		current_phase += 1
		current_state = BossState.IDLE

func handle_alt_quadrants_attack_state():
	if not is_in_out_attack_active:
		altQuadrants()
	elif not is_in_out_attack_active:
		current_phase += 1
		current_state = BossState.IDLE

func move_towards(target_position: Vector2):
	
	velocity = (target_position - position).normalized() * move_speed

func stop_movement():
	velocity = Vector2.ZERO

func update_animation():
	match current_state:
		BossState.IDLE:
			play_idle_animation()
		BossState.CHASING, BossState.MOVING_TO_CENTER:
			play_walk_animation()
		BossState.SLASHING:
			if not is_slashing:
				play_slash_animation()
		# Attacks handle their own animations

func play_idle_animation():
	var direction = get_facing_direction()
	animation_player.play("idle_" + direction)

func play_walk_animation():
	var direction = get_facing_direction()
	animation_player.play("walk_" + direction)

func play_slash_animation():
	var direction = get_facing_direction()
	animation_player.play("slash_" + direction)

func get_facing_direction() -> String:
	if velocity.x >= 0:
		return "right"
	else:
		return "left"
		

func slash():
	set_physics_process(false)
	is_slashing = true
	stop_movement()
	#print("movement stopped")
	var direction = get_facing_direction()
	animation_player.play("slash_" + direction)
	var animation_length = animation_player.get_animation("slash_right").length
	timer.start()
	
	await get_tree().create_timer(animation_length).timeout
	
	is_slashing = false
	slash_count += 1
	set_physics_process(true)

func inOutAttack():
	is_in_out_attack_active = true
	var inOutPick = randi_range(1, 2)
	if inOutPick == 1:
		boss_room_animation.play("attack_out")
	else:
		boss_room_animation.play("attack_in")
		
	var animation_length = boss_room_animation.get_animation("attack_out").length
	
	var charge_into_animation_length = animation_player.get_animation("charge_into").length
	var charge_animation_length = animation_player.get_animation("charge").length
	var charge_outof_animation_length = animation_player.get_animation("charge_outof").length

	animation_player.play("charge_into")
	await get_tree().create_timer(charge_into_animation_length).timeout

	animation_player.play("charge")
	await get_tree().create_timer(animation_length-charge_outof_animation_length-charge_into_animation_length-1).timeout

	animation_player.play("charge_outof")
	await get_tree().create_timer(charge_outof_animation_length).timeout
	
	var in_out_animation_length = animation_player.get_animation("attack_in_out_right").length
	#await get_tree().create_timer().timeout
	
	await get_tree().create_timer(in_out_animation_length).timeout
	
	is_in_out_attack_active = false
	
func altQuadrants():
	boss_room_animation.play("chargeup_alternate")
	var chargeup_length = boss_room_animation.get_animation("chargeup_alternate").length
	await get_tree().create_timer(chargeup_length).timeout
	
	boss_room_animation.play("alternate") # Start alternating quadrant attack
	var circleAOECount = 0
	var circle_aoe_length = circle_aoe_animation.get_animation("CircleAOE").length
	while circleAOECount < 7:
		circle_aoe.position = player.position
		circle_aoe.attack()
		await get_tree().create_timer(2.9988).timeout
		circleAOECount += 1
		#print(circleAOECount)
	
	# add in timing of circleAOE on player here or before idfk

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	is_player_in_slash_range = true
	#print("in range to hit player")
	

func _on_detection_area_body_exited(_body: Node2D) -> void:
	#player = null
	is_player_in_slash_range = false


#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#print("Hurtbox area entered")
	#if area.get_parent().has_method("get_damage_amount"):
		#var node = area.get_parent() as Node
		#health_amount -= node.damage_amount
		#print("Health amount: ", health_amount)

func _on_slash_hit_box_area_entered(area: Area2D):
	#print("(got hit by a slash... BRUH)")
	player.play_death()


func _on_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
	timer_2.start()
func _on_timer_2_timeout() -> void:
	collision.call_deferred("set", "disabled", true)
	
# Flash boss for when hit by player
func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()
func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)
