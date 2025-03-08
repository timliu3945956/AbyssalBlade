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
	await get_tree().create_timer(2.6656).timeout
	while circle_count < 8 and owner.boss_death == false:
		animation_player.play("alternate_slam")
		
		await get_tree().create_timer(0.3332).timeout
		#await get_tree().create_timer(0.8336).timeout #1.5 seconds in between circle hit
		circle()
		circle_count += 1
		await get_tree().create_timer(0.6664).timeout
		animation_player.play("idle_right")
		await get_tree().create_timer(1.9992).timeout
		# Animation of slam_down
		
		#await get_tree().create_timer(2.1652).timeout #1.5 seconds in between circle hit
		
	if owner.boss_death == false:
		var smoke_finish_tween = get_tree().create_tween()
		smoke_finish_tween.tween_property(owner.alternate_smoke, "modulate:a", 0, 0.5)
		#animation_player.play("oscillate_end")
		await get_tree().create_timer(0.5).timeout
		can_transition = true

func circle():
	if is_instance_valid(player):
		var circleAOE = CircleAOE.instantiate()
		circleAOE.position = player.position
		add_child(circleAOE)
		circleAOE.set_y_sort_enabled(false)
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		#if owner.timeline == 6:
			#match owner.choose_top_down:
				#1:
					#owner.boss_room_animation.play("top_transition")
				#2:
					#owner.boss_room_animation.play("bottom_transition")
			##owner.boss_room_animation.play("top_transition")
			#await owner.boss_room_animation.animation_finished
			
			#animation_player.play("mini_enrage")
			#await get_tree().create_timer(0.5833).timeout
			#match owner.choose_top_down:
				#1:
					#owner.smoke_top_1.play("smoke")
					#owner.smoke_top_2.play("smoke")
					#owner.boss_room_animation.play("top_charge")
					#spawn_shadow_audio.play()
				#2:
					#owner.smoke_bottom_1.play("smoke")
					#owner.smoke_bottom_2.play("smoke")
					#owner.boss_room_animation.play("bottom_charge")
					#spawn_shadow_audio.play()
			##owner.boss_room_animation.play("top_charge")
			#await animation_player.animation_finished
		get_parent().change_state("Transition")
