extends CenterContainer

@onready var cleave_animation: ColorRect = $ForegroundArena/CleaveAnimation
@onready var cleave_aim: Marker2D = $ForegroundArena/CleaveAim
@onready var player = get_node("Player")
@onready var boss_2_ranged: CharacterBody2D = $Boss2Ranged
@onready var boss_2_melee: CharacterBody2D = $Boss2Melee
@onready var boss_2: CharacterBody2D = $Boss2



@onready var lightning_1_triangle_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Lightning1
@onready var lightning_2_triangle_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Lightning2
@onready var lightning_3_triangle_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Marker2D/Lightning3
@onready var lightning_ember_0: AnimatedSprite2D = $Area2D/Marker2D6/LightningEmber0


@onready var lightning_1_triangle_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Lightning1
@onready var lightning_2_triangle_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Lightning2
@onready var lightning_3_triangle_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Marker2D/Lightning3
@onready var lightning_ember_1: AnimatedSprite2D = $Area2D/Marker2D5/LightningEmber1

@onready var lightning_1_triangle_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Lightning1
@onready var lightning_2_triangle_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Lightning2
@onready var lightning_3_triangle_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Marker2D/Lightning3
@onready var lightning_ember_2: AnimatedSprite2D = $Area2D/Marker2D4/LightningEmber2

@onready var lightning_1_triangle_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Lightning1
@onready var lightning_2_triangle_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Lightning2
@onready var lightning_3_triangle_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Marker2D/Lightning3
@onready var lightning_ember_3: AnimatedSprite2D = $Area2D/Marker2D3/LightningEmber3

@onready var lightning_1_triangle_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Lightning1
@onready var lightning_2_triangle_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Lightning2
@onready var lightning_3_triangle_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Marker2D/Lightning3
@onready var lightning_ember_4: AnimatedSprite2D = $Area2D/Marker2D2/LightningEmber4

@onready var lightning_1_triangle_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Lightning1
@onready var lightning_2_triangle_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Lightning2
@onready var lightning_3_triangle_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Marker2D/Lightning3
@onready var lightning_ember_5: AnimatedSprite2D = $Area2D/Marker2D/LightningEmber5

@onready var inner_circle_wind: AnimatedSprite2D = $Area2D/InnerCircleVFX/InnerCircleWind
@onready var inner_circle_lightning: AnimatedSprite2D = $Area2D/InnerCircleVFX/InnerCircleLightning
@onready var middle_circle_wind: AnimatedSprite2D = $Area2D/MiddleCircleVFX/MiddleCircleWind
@onready var middle_circle_lightning: AnimatedSprite2D = $Area2D/MiddleCircleVFX/MiddleCircleLightning
@onready var outer_circle_wind: AnimatedSprite2D = $Area2D/OuterCircleVFX/OuterCircleWind
@onready var outer_circle_lightning: AnimatedSprite2D = $Area2D/OuterCircleVFX/OuterCircleLightning

@onready var red_lightning_1: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning1
@onready var red_lightning_2: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning2
@onready var red_lightning_3: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning3
@onready var red_lightning_4: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning4
@onready var red_lightning_5: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning5
@onready var red_lightning_6: AnimatedSprite2D = $ForegroundArena/Marker2D2/RedLightning6

@onready var lightning_3: AnimatedSprite2D = $Area2D/InnerCircleVFX/Lightning3
@onready var lightning_ember_inner_1: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D/LightningEmber1
@onready var lightning_ember_inner_2: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D2/LightningEmber1
@onready var lightning_ember_inner_3: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D3/LightningEmber1
@onready var lightning_ember_inner_4: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D4/LightningEmber1
@onready var lightning_ember_inner_5: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D5/LightningEmber1
@onready var lightning_ember_inner_6: AnimatedSprite2D = $Area2D/InnerCircleVFX/Marker2D6/LightningEmber1

@onready var lightning_vfx_middle_1: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D/Lightning4
@onready var lightning_vfx_middle_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D2/Lightning4
@onready var lightning_vfx_middle_3: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D3/Lightning4
@onready var lightning_vfx_middle_4: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D4/Lightning4
@onready var lightning_vfx_middle_5: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D5/Lightning4
@onready var lightning_vfx_middle_6: AnimatedSprite2D = $Area2D/MiddleCircleVFX/Marker2D6/Lightning4

@onready var lightning_ember_middle_1: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_3: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_4: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_5: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_6: AnimatedSprite2D = $Area2D/MiddleCircleVFX/EmberMarker6/LightningEmber2

@onready var middle_circle_lightning_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/MiddleCircleLightning
@onready var middle_circle_wind_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/MiddleCircleWind
@onready var lightning_vfx_second_1: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D/Lightning4
@onready var lightning_vfx_second_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D2/Lightning4
@onready var lightning_vfx_second_3: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D3/Lightning4
@onready var lightning_vfx_second_4: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D4/Lightning4
@onready var lightning_vfx_second_5: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D5/Lightning4
@onready var lightning_vfx_second_6: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/Marker2D6/Lightning4
@onready var lightning_ember_middle_second_1: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_second_2: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_second_3: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_second_4: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_second_5: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_second_6: AnimatedSprite2D = $Area2D/MiddleCircleVFX2/EmberMarker6/LightningEmber2



@onready var lightning_vfx_outer_1: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D/Lightning4
@onready var lightning_vfx_outer_2: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D2/Lightning4
@onready var lightning_vfx_outer_3: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D3/Lightning4
@onready var lightning_vfx_outer_4: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D4/Lightning4
@onready var lightning_vfx_outer_5: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D5/Lightning4
@onready var lightning_vfx_outer_6: AnimatedSprite2D = $Area2D/OuterCircleVFX/Marker2D6/Lightning4

@onready var lightning_ember_outer_1: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker1/LightningEmber3
@onready var lightning_ember_outer_2: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker2/LightningEmber3
@onready var lightning_ember_outer_3: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker3/LightningEmber3
@onready var lightning_ember_outer_4: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker4/LightningEmber3
@onready var lightning_ember_outer_5: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker5/LightningEmber3
@onready var lightning_ember_outer_6: AnimatedSprite2D = $Area2D/OuterCircleVFX/EmberMarker6/LightningEmber3


@onready var circle_lightning_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/CircleLightning
@onready var circle_lightning_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/CircleLightning
@onready var circle_lightning_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Phase2/CircleLightning
@onready var circle_lightning_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/CircleLightning
@onready var circle_lightning_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/CircleLightning
@onready var circle_lightning_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Node2D/CircleLightning

@onready var lightning_phase2_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/Marker2D2/Lightning4
@onready var lightning_phase2_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/Marker2D/Lightning4
@onready var lightning_phase2_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Phase2/Marker2D3/Lightning4
@onready var lightning_phase2_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/Marker2D4/Lightning4
@onready var lightning_phase2_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/Marker2D5/Lightning4
@onready var lightning_phase2_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Node2D/Marker2D6/Lightning4

@onready var lightning_ember_phase2_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/EmberMarker2/LightningEmber2
@onready var lightning_ember_phase2_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/EmberMarker3/LightningEmber2
@onready var lightning_ember_phase2_2: AnimatedSprite2D = $Area2D/Triangle2VFX/Phase2/EmberMarker6/LightningEmber2
@onready var lightning_ember_phase2_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/EmberMarker5/LightningEmber2
@onready var lightning_ember_phase2_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/EmberMarker4/LightningEmber2
@onready var lightning_ember_phase2_5: AnimatedSprite2D = $Area2D/Triangle5VFX/Node2D/EmberMarker1/LightningEmber2

@onready var circle_lightning_second_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/CircleLightning2
@onready var lightning_second_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/Marker2D2/Lightning5
@onready var lightning_ember_second_0: AnimatedSprite2D = $Area2D/Triangle0VFX/Phase2/EmberMarker2/LightningEmber3
@onready var circle_lightning_second_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/CircleLightning2
@onready var lightning_second_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/Marker2D/Lightning5
@onready var lightning_ember_second_1: AnimatedSprite2D = $Area2D/Triangle1VFX/Phase2/EmberMarker3/LightningEmber3
@onready var circle_lightning_second_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/CircleLightning2
@onready var lightning_second_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/Marker2D4/Lightning5
@onready var lightning_ember_second_3: AnimatedSprite2D = $Area2D/Triangle3VFX/Phase2/EmberMarker5/LightningEmber3
@onready var circle_lightning_second_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/CircleLightning2
@onready var lightning_second_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/Marker2D5/Lightning5
@onready var lightning_ember_second_4: AnimatedSprite2D = $Area2D/Triangle4VFX/Phase2/EmberMarker4/LightningEmber3




@onready var outer_collision: CollisionPolygon2D = $Area2D/OuterCollision


@onready var sac_aoe_1: AnimatedSprite2D = $Area2D/SacAOE1
@onready var sac_aoe_2: AnimatedSprite2D = $Area2D/SacAOE2

var ranged_special_2 = preload("res://Other/ranged_special_part_2.tscn")
var ranged_special_initial_2 = preload("res://Other/ranged_special_initial_2.tscn")

@onready var cutscene_animation_player: AnimationPlayer = $CutsceneAnimationPlayer
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var camera_2d: Camera2D = $Player/Camera2D



#var beam_bar = preload("res://Utilities/cast bar/BeamCircle/beam_progress.tscn")
#@onready var beam_timer: Timer = $BeamTimer
#var circle_ref: Node2D


var center_of_screen = get_viewport_rect().size / 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#if Global.player_data.cutscene_viewed_boss_3 == false:
		#start_cutscene()
		#Global.player_data.cutscene_viewed_boss_3 = true
		#Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
	
	AudioPlayer.stop_music()
	GlobalCount.reset_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta
	
	#if beam_timer.time_left > 0:
		#circle_ref.position = Vector2(400, 300)
		#print("cricle_ref pos", circle_ref.global_position)
func start_cutscene():
	player.set_process_input(false)
	player.set_physics_process(false)
	cutscene_camera.make_current()

	cutscene_animation_player.play("boss_intro")
	await cutscene_animation_player.animation_finished
	#cutscene_camera.current = false
	camera_2d.make_current()
	player.set_process_input(true)
	player.set_physics_process(true)

		
func inner_melee_special_vfx():
	inner_circle_wind.play("default")
	inner_circle_lightning.play("default")
	lightning_3.play("default")
	lightning_ember_inner_1.play("default")
	lightning_ember_inner_2.play("default")
	lightning_ember_inner_3.play("default")
	lightning_ember_inner_4.play("default")
	lightning_ember_inner_5.play("default")
	lightning_ember_inner_6.play("default")
	
	#var inner_wind = create_tween()
	#inner_wind.tween_property(inner_circle_wind, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	#var inner_lightning = create_tween()
	#inner_lightning.tween_property(inner_circle_lightning, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	
func middle_melee_special_vfx():
	middle_circle_wind.play("default")
	middle_circle_lightning.play("default")
	lightning_vfx_middle_1.play("default")
	lightning_vfx_middle_2.play("default")
	lightning_vfx_middle_3.play("default")
	lightning_vfx_middle_4.play("default")
	lightning_vfx_middle_5.play("default")
	lightning_vfx_middle_6.play("default")
	lightning_ember_middle_1.play("default")
	lightning_ember_middle_2.play("default")
	lightning_ember_middle_3.play("default")
	lightning_ember_middle_4.play("default")
	lightning_ember_middle_5.play("default")
	lightning_ember_middle_6.play("default")
	
	#var middle_wind = create_tween()
	#middle_wind.tween_property(middle_circle_wind, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	#var middle_lightning = create_tween()
	#middle_lightning.tween_property(middle_circle_lightning, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	
func middle_second_melee_special_vfx():
	middle_circle_lightning_2.play("default")
	middle_circle_wind_2.play("default")
	lightning_vfx_second_1.play("default")
	lightning_vfx_second_2.play("default")
	lightning_vfx_second_3.play("default")
	lightning_vfx_second_4.play("default")
	lightning_vfx_second_5.play("default")
	lightning_vfx_second_6.play("default")
	lightning_ember_middle_second_1.play("default")
	lightning_ember_middle_second_2.play("default")
	lightning_ember_middle_second_3.play("default")
	lightning_ember_middle_second_4.play("default")
	lightning_ember_middle_second_5.play("default")
	lightning_ember_middle_second_6.play("default")
	#var middle_second_wind = create_tween()
	#middle_second_wind.tween_property(middle_circle_lightning_2, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	#var middle_second_lightning = create_tween()
	#middle_second_lightning.tween_property(middle_circle_wind_2, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	
func outer_melee_special_vfx():
	outer_circle_wind.play("default")
	outer_circle_lightning.play("default")
	lightning_vfx_outer_1.play("default")
	lightning_vfx_outer_2.play("default")
	lightning_vfx_outer_3.play("default")
	lightning_vfx_outer_4.play("default")
	lightning_vfx_outer_5.play("default")
	lightning_vfx_outer_6.play("default")
	lightning_ember_outer_1.play("default")
	lightning_ember_outer_2.play("default")
	lightning_ember_outer_3.play("default")
	lightning_ember_outer_4.play("default")
	lightning_ember_outer_5.play("default")
	lightning_ember_outer_6.play("default")
	outer_collision.disabled = false
	await get_tree().create_timer(0.0833).timeout
	outer_collision.disabled = true
	#var outer_wind = create_tween()
	#outer_wind.tween_property(outer_circle_wind, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	#var outer_lightning = create_tween()
	#outer_lightning.tween_property(outer_circle_lightning, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	
	
func enrage_attack():
	inner_circle_wind.play("default")
	inner_circle_lightning.play("default")
	lightning_3.play("default")
	lightning_ember_inner_1.play("default")
	lightning_ember_inner_2.play("default")
	lightning_ember_inner_3.play("default")
	lightning_ember_inner_4.play("default")
	lightning_ember_inner_5.play("default")
	lightning_ember_inner_6.play("default")
	
	middle_circle_wind.play("default")
	middle_circle_lightning.play("default")
	lightning_vfx_middle_1.play("default")
	lightning_vfx_middle_2.play("default")
	lightning_vfx_middle_3.play("default")
	lightning_vfx_middle_4.play("default")
	lightning_vfx_middle_5.play("default")
	lightning_vfx_middle_6.play("default")
	lightning_ember_middle_1.play("default")
	lightning_ember_middle_2.play("default")
	lightning_ember_middle_3.play("default")
	lightning_ember_middle_4.play("default")
	lightning_ember_middle_5.play("default")
	lightning_ember_middle_6.play("default")
	
	outer_circle_wind.play("default")
	outer_circle_lightning.play("default")
	lightning_vfx_outer_1.play("default")
	lightning_vfx_outer_2.play("default")
	lightning_vfx_outer_3.play("default")
	lightning_vfx_outer_4.play("default")
	lightning_vfx_outer_5.play("default")
	lightning_vfx_outer_6.play("default")
	lightning_ember_outer_1.play("default")
	lightning_ember_outer_2.play("default")
	lightning_ember_outer_3.play("default")
	lightning_ember_outer_4.play("default")
	lightning_ember_outer_5.play("default")
	lightning_ember_outer_6.play("default")
#func range_special_vfx():
	#red_lightning_1.play("default")
	#red_lightning_2.play("default")
	#red_lightning_3.play("default")
	#red_lightning_4.play("default")
	#red_lightning_5.play("default")
	#red_lightning_6.play("default")

func spawn_special_part_2(second_await: bool = false, end_degrees: float = 450.0, step: float = 22.5, timeout: float = 0.5, timeout_first: float = 1.5) -> void:
	var deg: float = 0.0
	
	if end_degrees == 450.0:
		if second_await:
			await get_tree().create_timer(1).timeout
		while (deg < end_degrees):
			if deg == 0.0:
				var range_line_first = ranged_special_initial_2.instantiate()
				range_line_first.rotation_degrees = -deg
				add_child(range_line_first)
				if timeout_first > 0:
					await get_tree().create_timer(timeout_first).timeout
			else:
				var range_line = ranged_special_2.instantiate()
				range_line.rotation_degrees = -deg
				add_child(range_line)
				if timeout > 0:
					await get_tree().create_timer(timeout).timeout
			deg += step
			if deg == 180.0 and second_await:
				boss_2_melee.find_child("FiniteStateMachine").change_state("Foretold")
			if deg == 157.5 and !second_await:
				boss_2.melee_slam_special(boss_2.target_position)
				boss_2.melee_slam_special(boss_2.opposite_position)
			if deg == 337.5 and !second_await:
				boss_2.melee_slam_special(boss_2.target_position)
				boss_2.melee_slam_special(boss_2.opposite_position)
	#else:
		#while (deg > end_degrees):
			#if deg == 0.0:
				#var range_line_first = ranged_special_initial_2.instantiate()
				#range_line_first.rotation_degrees = deg
				#add_child(range_line_first)
				#if timeout_first > 0:
					#await get_tree().create_timer(timeout_first).timeout
			#else:
				#var range_line = ranged_special_2.instantiate()
				#range_line.rotation_degrees = deg
				#add_child(range_line)
				#if timeout > 0:
					#await get_tree().create_timer(timeout).timeout
			#deg += step
			#if deg == -180.0:
				#boss_2.melee_slam_special(boss_2.target_position)
				#boss_2.melee_slam_special(boss_2.opposite_position)
			#if deg == -405.0:
				#boss_2.melee_slam_special(boss_2.target_position)
				#boss_2.melee_slam_special(boss_2.opposite_position)
	
	#for float(deg in range(0.0, -450.0, -22.5):
		#if deg == 0.0:
			#var range_line_first = ranged_special_initial_2.instantiate()
			#range_line_first.rotation_degrees = deg
			#add_child(range_line_first)
			#if timeout > 0:
				#await get_tree().create_timer(timeout_first).timeout
		#else:
			#var range_line = ranged_special_2.instantiate()
			#range_line.rotation_degrees = deg
			#add_child(range_line)
			#if timeout > 0:
				#await get_tree().create_timer(timeout).timeout
		#print("deg print: ", float(deg))
	await get_tree().create_timer(2).timeout
	#await get_tree().create_timer(3).timeout
		#if timeout > 0:
			##if 
			#await get_tree().create_timer(timeout).timeout
			

func _on_triangle_telegraph_long_animation_player_animation_finished(anim_name: StringName) -> void:
	print("triangle: ", anim_name)
	if anim_name == "triangle_0":
		lightning_1_triangle_0.play("default")
		lightning_2_triangle_0.play("default")
		lightning_3_triangle_0.play("default")
		lightning_ember_0.play("default")
	elif anim_name == "triangle_1":
		lightning_1_triangle_1.play("default")
		lightning_2_triangle_1.play("default")
		lightning_3_triangle_1.play("default")
		lightning_ember_1.play("default")
	elif anim_name == "triangle_2":
		lightning_1_triangle_2.play("default")
		lightning_2_triangle_2.play("default")
		lightning_3_triangle_2.play("default")
		lightning_ember_2.play("default")
	elif anim_name == "triangle_3":
		lightning_1_triangle_3.play("default")
		lightning_2_triangle_3.play("default")
		lightning_3_triangle_3.play("default")
		lightning_ember_3.play("default")
	elif anim_name == "triangle_4":
		lightning_1_triangle_4.play("default")
		lightning_2_triangle_4.play("default")
		lightning_3_triangle_4.play("default")
		lightning_ember_4.play("default")
	elif anim_name == "triangle_5":
		lightning_1_triangle_5.play("default")
		lightning_2_triangle_5.play("default")
		lightning_3_triangle_5.play("default")
		lightning_ember_5.play("default")


func _on_triangle_telegraph_animation_player_animation_finished(anim_name: StringName) -> void:
	print("triangle: ", anim_name)
	if anim_name == "triangle_0":
		lightning_1_triangle_0.play("default")
		lightning_2_triangle_0.play("default")
		lightning_3_triangle_0.play("default")
		lightning_ember_0.play("default")
	elif anim_name == "triangle_1":
		lightning_1_triangle_1.play("default")
		lightning_2_triangle_1.play("default")
		lightning_3_triangle_1.play("default")
		lightning_ember_1.play("default")
	elif anim_name == "triangle_2":
		lightning_1_triangle_2.play("default")
		lightning_2_triangle_2.play("default")
		lightning_3_triangle_2.play("default")
		lightning_ember_2.play("default")
	elif anim_name == "triangle_3":
		lightning_1_triangle_3.play("default")
		lightning_2_triangle_3.play("default")
		lightning_3_triangle_3.play("default")
		lightning_ember_3.play("default")
	elif anim_name == "triangle_4":
		lightning_1_triangle_4.play("default")
		lightning_2_triangle_4.play("default")
		lightning_3_triangle_4.play("default")
		lightning_ember_4.play("default")
	elif anim_name == "triangle_5":
		lightning_1_triangle_5.play("default")
		lightning_2_triangle_5.play("default")
		lightning_3_triangle_5.play("default")
		lightning_ember_5.play("default")

func _on_triangle_telegraph_animation_player_2_animation_finished(anim_name: StringName) -> void:
	print("triangle: ", anim_name)
	if anim_name == "triangle_0":
		lightning_1_triangle_0.play("default")
		lightning_2_triangle_0.play("default")
		lightning_3_triangle_0.play("default")
		lightning_ember_0.play("default")
	elif anim_name == "triangle_1":
		lightning_1_triangle_1.play("default")
		lightning_2_triangle_1.play("default")
		lightning_3_triangle_1.play("default")
		lightning_ember_1.play("default")
	elif anim_name == "triangle_2":
		lightning_1_triangle_2.play("default")
		lightning_2_triangle_2.play("default")
		lightning_3_triangle_2.play("default")
		lightning_ember_2.play("default")
	elif anim_name == "triangle_3":
		lightning_1_triangle_3.play("default")
		lightning_2_triangle_3.play("default")
		lightning_3_triangle_3.play("default")
		lightning_ember_3.play("default")
	elif anim_name == "triangle_4":
		lightning_1_triangle_4.play("default")
		lightning_2_triangle_4.play("default")
		lightning_3_triangle_4.play("default")
		lightning_ember_4.play("default")
	elif anim_name == "triangle_5":
		lightning_1_triangle_5.play("default")
		lightning_2_triangle_5.play("default")
		lightning_3_triangle_5.play("default")
		lightning_ember_5.play("default")
		
func phase_1_triangle_impact_0():
	lightning_1_triangle_0.play("default")
	lightning_2_triangle_0.play("default")
	lightning_3_triangle_0.play("default")
	lightning_ember_0.play("default")

func phase_1_triangle_impact_1():
	lightning_1_triangle_1.play("default")
	lightning_2_triangle_1.play("default")
	lightning_3_triangle_1.play("default")
	lightning_ember_1.play("default")
	
func phase_1_triangle_impact_2():
	lightning_1_triangle_2.play("default")
	lightning_2_triangle_2.play("default")
	lightning_3_triangle_2.play("default")
	lightning_ember_2.play("default")
	
func phase_1_triangle_impact_3():
	lightning_1_triangle_3.play("default")
	lightning_2_triangle_3.play("default")
	lightning_3_triangle_3.play("default")
	lightning_ember_3.play("default")
	
func phase_1_triangle_impact_4():
	lightning_1_triangle_4.play("default")
	lightning_2_triangle_4.play("default")
	lightning_3_triangle_4.play("default")
	lightning_ember_4.play("default")

func phase_1_triangle_impact_5():
	lightning_1_triangle_5.play("default")
	lightning_2_triangle_5.play("default")
	lightning_3_triangle_5.play("default")
	lightning_ember_5.play("default")

func phase_2_triangle_destruction_0():
	lightning_1_triangle_0.play("default")
	lightning_2_triangle_0.play("default")
	lightning_3_triangle_0.play("default")
	lightning_ember_0.play("default")
	
func phase_2_triangle_destruction_1():
	lightning_1_triangle_1.play("default")
	lightning_2_triangle_1.play("default")
	lightning_3_triangle_1.play("default")
	lightning_ember_1.play("default")
	
func phase_2_triangle_destruction_2():
	lightning_1_triangle_2.play("default")
	lightning_2_triangle_2.play("default")
	lightning_3_triangle_2.play("default")
	lightning_ember_2.play("default")
	
func phase_2_triangle_destruction_3():
	lightning_1_triangle_3.play("default")
	lightning_2_triangle_3.play("default")
	lightning_3_triangle_3.play("default")
	lightning_ember_3.play("default")
	
func phase_2_triangle_destruction_4():
	lightning_1_triangle_4.play("default")
	lightning_2_triangle_4.play("default")
	lightning_3_triangle_4.play("default")
	lightning_ember_4.play("default")
	
func phase_2_triangle_destruction_5():
	lightning_1_triangle_5.play("default")
	lightning_2_triangle_5.play("default")
	lightning_3_triangle_5.play("default")
	lightning_ember_5.play("default")
		
func phase_2_triangle_vfx_0():
	circle_lightning_0.play("default")
	lightning_phase2_0.play("default")
	lightning_ember_phase2_0.play("default")
	
func phase_2_triangle_vfx_1():
	circle_lightning_1.play("default")
	lightning_phase2_1.play("default")
	lightning_ember_phase2_1.play("default")
	
func phase_2_triangle_vfx_2():
	circle_lightning_2.play("default")
	lightning_phase2_2.play("default")
	lightning_ember_phase2_2.play("default")
	
func phase_2_triangle_vfx_3():
	circle_lightning_3.play("default")
	lightning_phase2_3.play("default")
	lightning_ember_phase2_3.play("default")
	
func phase_2_triangle_vfx_4():
	circle_lightning_4.play("default")
	lightning_phase2_4.play("default")
	lightning_ember_phase2_4.play("default")
	
func phase_2_triangle_vfx_5():
	circle_lightning_5.play("default")
	lightning_phase2_5.play("default")
	lightning_ember_phase2_5.play("default")
	
func phase_2_triangle_vfx_second_0():
	circle_lightning_second_0.play("default")
	lightning_second_0.play("default")
	lightning_ember_second_0.play("default")
	
func phase_2_triangle_vfx_second_1():
	circle_lightning_second_1.play("default")
	lightning_second_1.play("default")
	lightning_ember_second_1.play("default")
	
func phase_2_triangle_vfx_second_3():
	circle_lightning_second_3.play("default")
	lightning_second_3.play("default")
	lightning_ember_second_3.play("default")
func phase_2_triangle_vfx_second_4():
	circle_lightning_second_4.play("default")
	lightning_second_4.play("default")
	lightning_ember_second_4.play("default")
func arena_death_vfx():
	sac_aoe_1.play("default")
	sac_aoe_2.play("default")
	
#func beam_circle():
	#circle_ref = beam_bar.instantiate()
	#add_child(circle_ref)
	#beam_timer.start()
	#circle_ref.position = Vector2(400, 300)
	#print("beam being instantiated")

#func _on_beam_timer_timeout() -> void:
	#if circle_ref and circle_ref.get_parent() == self:
		#var temp_pos: Vector2 = circle_ref.global_position
		#remove_child(circle_ref)
		#get_tree().get_current_scene().add_child(circle_ref)
		#circle_ref.global_position = global_position
		##circle_ref.global_position = temp_pos
