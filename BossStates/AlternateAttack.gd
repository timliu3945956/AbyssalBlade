extends State

@onready var spawn_shadow_audio: AudioStreamPlayer2D = $"../../SpawnShadowAudio"

var CircleAOE = preload("res://Characters/circle_aoe.tscn")
var can_transition: bool = false
var circle_count = 0

var choose_alternate = randi_range(1, 2)

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	
	owner.boss_room_animation.play("chargeup_alternate")
	animation_player.play("idle_right")
	await owner.boss_room_animation.animation_finished
	
	var smoke_tween = get_tree().create_tween()
	smoke_tween.tween_property(owner.alternate_smoke, "modulate:a", 1, 0.5)
	#owner.boss_room_animation.play("alternate")
	match choose_alternate:
		1:
			owner.smoke_alternate_1.play("smoke")
			owner.smoke_alternate_2.play("smoke")
			owner.boss_room_animation.play("alternate")
		2:
			owner.smoke_alternate_opposite_1.play("smoke")
			owner.smoke_alternate_opposite_2.play("smoke")
			owner.boss_room_animation.play("alternate_opposite")
			
	#animation_player.play("alternate_slam_disappear")
	player.beam_circle_meteor()
	await TimeWait.wait_sec(2.6656)#await get_tree().create_timer(2.6656).timeout
	while circle_count < 8 and owner.boss_death == false:
		animation_player.play("alternate_slam")
		
		await TimeWait.wait_sec(0.3332)#await get_tree().create_timer(0.3332).timeout
		owner.beam_circle()
		circle()
		circle_count += 1
		if circle_count < 8:
			player.beam_circle_meteor()
			
		await TimeWait.wait_sec(0.6664)#await get_tree().create_timer(0.6664).timeout
		animation_player.play("idle_right")
		await TimeWait.wait_sec(1.9992)#await get_tree().create_timer(1.9992).timeout
		
	if owner.boss_death == false:
		var smoke_finish_tween = get_tree().create_tween()
		smoke_finish_tween.tween_property(owner.alternate_smoke, "modulate:a", 0, 0.5)
		await TimeWait.wait_sec(0.5)#await get_tree().create_timer(0.5).timeout
		can_transition = true

func circle():
	if is_instance_valid(player):
		var circleAOE = CircleAOE.instantiate()
		circleAOE.position = player.position
		circleAOE.boss = owner
		add_child(circleAOE)
		circleAOE.set_y_sort_enabled(false)
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
