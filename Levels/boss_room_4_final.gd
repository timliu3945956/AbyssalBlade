extends CenterContainer
@onready var player: CharacterBody2D = $Player
@onready var boss_4: CharacterBody2D = $Boss4Final
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var camera: Camera2D = $Player/Camera2D

@onready var boss_room_animation_player: AnimationPlayer = $BossRoomAnimationPlayer
@onready var room_change_player: AnimationPlayer = $RoomChangePlayer

@onready var enrage_background: AnimationPlayer = $EnrageBackground

@onready var plunge_in_marker: Marker2D = $PlungeArea2D/PlungeInVFX/Marker2D
@onready var plunge_out_marker: Marker2D = $PlungeArea2D/PlungeOutVFX/Marker2D

@onready var debuff_attacks: Node2D = $DebuffAttacks

@onready var oblivion_pass_dark_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionPassDarkVFX
@onready var oblivion_pass_gold_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionPassGoldVFX
@onready var oblivion_fail_vfx: AnimatedSprite2D = $OblivionArea2D/OblivionFailVFX
@onready var oblivion_pass: CollisionPolygon2D = $OblivionArea2D/OblivionPass
@onready var dark_wind_vfx: AnimatedSprite2D = $OblivionArea2D/DarkWindVFX

@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var player_cutscene_sprite: Sprite2D = $PlayerCutsceneSprite
@onready var boss_cutscene_sprite: Sprite2D = $BossCutsceneSprite
@onready var knockback_effect: AnimatedSprite2D = $KnockbackEffect
@onready var light_anim: AnimatedSprite2D = $LightAnim
@onready var foreground_arena: Sprite2D = $ForegroundArena

@onready var invisible_attack_audio: AudioStreamPlayer2D = $invisible_attack_audio
@onready var in_out_alternate_audio: AudioStreamPlayer2D = $in_out_alternate_audio
@onready var boss_killed: Node2D = $Portal

@onready var boss_music: AudioStreamPlayer2D = $BossMusicAudio

# BOSS 3 ONREADY
@onready var inner_circle_wind: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/InnerCircleWind
@onready var inner_circle_lightning: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/InnerCircleLightning
@onready var middle_circle_wind: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/MiddleCircleWind
@onready var middle_circle_lightning: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/MiddleCircleLightning
@onready var outer_circle_wind: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/OuterCircleWind
@onready var outer_circle_lightning: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/OuterCircleLightning

@onready var lightning_3: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Lightning3
@onready var lightning_ember_inner_1: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D/LightningEmber1
@onready var lightning_ember_inner_2: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D2/LightningEmber1
@onready var lightning_ember_inner_3: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D3/LightningEmber1
@onready var lightning_ember_inner_4: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D4/LightningEmber1
@onready var lightning_ember_inner_5: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D5/LightningEmber1
@onready var lightning_ember_inner_6: AnimatedSprite2D = $Boss2CollisionVFX/InnerCircleVFX/Marker2D6/LightningEmber1

@onready var lightning_vfx_middle_1: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D/Lightning4
@onready var lightning_vfx_middle_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D2/Lightning4
@onready var lightning_vfx_middle_3: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D3/Lightning4
@onready var lightning_vfx_middle_4: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D4/Lightning4
@onready var lightning_vfx_middle_5: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D5/Lightning4
@onready var lightning_vfx_middle_6: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/Marker2D6/Lightning4

@onready var lightning_ember_middle_1: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_3: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_4: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_5: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_6: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX/EmberMarker6/LightningEmber2

@onready var middle_circle_lightning_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/MiddleCircleLightning
@onready var middle_circle_wind_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/MiddleCircleWind
@onready var lightning_vfx_second_1: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D/Lightning4
@onready var lightning_vfx_second_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D2/Lightning4
@onready var lightning_vfx_second_3: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D3/Lightning4
@onready var lightning_vfx_second_4: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D4/Lightning4
@onready var lightning_vfx_second_5: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D5/Lightning4
@onready var lightning_vfx_second_6: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/Marker2D6/Lightning4
@onready var lightning_ember_middle_second_1: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_second_2: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_second_3: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_second_4: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_second_5: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_second_6: AnimatedSprite2D = $Boss2CollisionVFX/MiddleCircleVFX2/EmberMarker6/LightningEmber2

@onready var lightning_vfx_outer_1: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D/Lightning4
@onready var lightning_vfx_outer_2: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D2/Lightning4
@onready var lightning_vfx_outer_3: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D3/Lightning4
@onready var lightning_vfx_outer_4: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D4/Lightning4
@onready var lightning_vfx_outer_5: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D5/Lightning4
@onready var lightning_vfx_outer_6: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/Marker2D6/Lightning4

@onready var lightning_ember_outer_1: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker1/LightningEmber3
@onready var lightning_ember_outer_2: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker2/LightningEmber3
@onready var lightning_ember_outer_3: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker3/LightningEmber3
@onready var lightning_ember_outer_4: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker4/LightningEmber3
@onready var lightning_ember_outer_5: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker5/LightningEmber3
@onready var lightning_ember_outer_6: AnimatedSprite2D = $Boss2CollisionVFX/OuterCircleVFX/EmberMarker6/LightningEmber3

@onready var outer_collision: CollisionPolygon2D = $Boss2CollisionVFX/OuterCollision

@onready var black_wind_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/BlackWind
@onready var black_bubble_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/BlackBubble
@onready var white_bubble_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/WhiteBubble
@onready var white_wind_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/WhiteWind

@onready var black_bubble_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/BlackBubble
@onready var white_bubble_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/WhiteBubble
@onready var black_wind_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/BlackWind
@onready var white_wind_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/WhiteWind

@onready var static_outer_arena: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var telegraphs: Node2D = $Telegraphs
@onready var boss_1_collision_vfx: Area2D = $Boss1CollisionVFX
@onready var boss_2_collision_vfx: Area2D = $Boss2CollisionVFX
@onready var oppressive_vfx: Node2D = $OppressiveVFX
@onready var area_attacks: Area2D = $AreaAttacks
@onready var circle_0_light: PointLight2D = $Circle0Light
@onready var circle_1_light: PointLight2D = $Circle1Light
@onready var circle_2_light: PointLight2D = $Circle2Light
@onready var circle_3_light: PointLight2D = $Circle3Light
@onready var circle_4_light: PointLight2D = $Circle4Light
@onready var circle_5_light: PointLight2D = $Circle5Light
@onready var circle_6_light: PointLight2D = $Circle6Light
@onready var circle_7_light: PointLight2D = $Circle7Light
@onready var sword_drop_1_1: Sprite2D = $"SwordDrop1,1"
@onready var sword_drop_1_2: Sprite2D = $"SwordDrop1,2"
@onready var sword_drop_1_3: Sprite2D = $"SwordDrop1,3"
@onready var sword_drop_1_4: Sprite2D = $"SwordDrop1,4"
@onready var sword_drop_2_1: Sprite2D = $"SwordDrop2,1"
@onready var sword_drop_2_2: Sprite2D = $"SwordDrop2,2"
@onready var sword_drop_2_3: Sprite2D = $"SwordDrop2,3"
@onready var sword_drop_2_4: Sprite2D = $"SwordDrop2,4"
@onready var sword_drop_3_1: Sprite2D = $"SwordDrop3,1"
@onready var sword_drop_3_2: Sprite2D = $"SwordDrop3,2"
@onready var sword_drop_3_3: Sprite2D = $"SwordDrop3,3"
@onready var sword_drop_3_4: Sprite2D = $"SwordDrop3,4"
@onready var sword_drop_4_1: Sprite2D = $"SwordDrop4,1"
@onready var sword_drop_4_2: Sprite2D = $"SwordDrop4,2"
@onready var sword_drop_4_3: Sprite2D = $"SwordDrop4,3"
@onready var sword_drop_4_4: Sprite2D = $"SwordDrop4,4"
@onready var shadow_particle: GPUParticles2D = $ShadowParticle
@onready var sparkle_burst: AnimatedSprite2D = $PlayerCutsceneSprite/SparkleBurst
@onready var end_music: AudioStreamPlayer2D = $EndMusic
@onready var arena_reappear: Sprite2D = $ArenaReappear
@onready var parallax_background: ParallaxBackground = $ParallaxBackground

@onready var devour_circle: Sprite2D = $Devour/DevourCircle
@onready var ground_aura_1: AnimatedSprite2D = $Devour/DevourCircle/GroundAura1
@onready var ground_aura_2: AnimatedSprite2D = $Devour/DevourCircle/GroundAura2
@onready var devour_circle_animation: AnimationPlayer = $Devour/DevourCircleAnimation
@onready var devour_orb_spawn: Node2D = $DevourOrbSpawn


var boss_stage_textures := {
	"denial": preload("res://sprites/tilesets/UpdatedStages/arena_v09.png"),
	"anger": preload("res://sprites/tilesets/UpdatedStages/Foreground_v03.png"),
	"bargain": preload("res://sprites/tilesets/UpdatedStages/bargain_arena5.png"),
	"depression": preload("res://sprites/tilesets/UpdatedStages/depression_arena_v04.png"),
	"grief": preload("res://sprites/tilesets/UpdatedStages/grief_arena_v4.png")
}

var octahit = preload("res://Other/ThreeLineAOE.tscn")
var gold_clone = preload("res://Other/gold_clone.tscn")
var cleave = preload("res://Other/half_room_cleave.tscn")
var glass_shard = preload("res://Other/GlassShard.tscn")

var ranged_special_2 = preload("res://Other/ranged_special_part_2.tscn")
var ranged_special_initial_2 = preload("res://Other/ranged_special_initial_2.tscn")
var ranged_audio = preload("res://Other/ranged_special_audio.tscn")
var range_special_audio
var range_line = ranged_special_2.instantiate()
var range_line_first = ranged_special_initial_2.instantiate()
var spawn_clone: Node = null

func _ready() -> void:
	static_outer_arena.disabled = true
	AudioPlayer.stop_music()
	GlobalCount.camera = player.camera
	
	GlobalCount.paused = true
	player.set_process(false)
	player.set_physics_process(false)
	enrage_background.play("flash_screen_start")
	await enrage_background.animation_finished
	GlobalCount.stage_select_pause = false
	GlobalCount.in_subtree_menu = false
	player.set_process(true)
	player.set_physics_process(true)
	GlobalCount.paused = false

func _process(delta: float) -> void:
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta
		
func camera_shake():
	GlobalCount.camera.apply_shake(16.0, 15.0)

func spawn_octahit():
	var spawn_hit = octahit.instantiate()
	spawn_hit.player = player
	spawn_hit.boss = boss_4
	add_child(spawn_hit)

func spawn_gold_clone():
	spawn_clone = gold_clone.instantiate()
	spawn_clone.player = player
	spawn_clone.boss = boss_4
	add_child(spawn_clone)
	
func spawn_shield():
	if is_instance_valid(spawn_clone):
		spawn_clone.animation_player.play("raise_sword")
		
func check_clone_alive():
	if is_instance_valid(spawn_clone):
		print("playing oblivion_pass")
		move_oblivion_collision_vfx()
		#await get_tree().create_timer(0.1667).timeout
		boss_room_animation_player.play("oblivion_pass")
	else:
		print("playing oblivion_fail")
		#await get_tree().create_timer(0.1667).timeout
		boss_room_animation_player.play("oblivion_fail")

#func _on_debuff_finished(attack_name: String) -> void:
	#debuff_attacks.global_position = player.global_position
	#debuff_attacks.animation_player.play(attack_name)
		
func reset_smoothing():
	camera.reset_smoothing()
	
func start_oblivion_vfx():
	oblivion_pass_dark_vfx.play("default")
	oblivion_pass_gold_vfx.play("default")
	oblivion_fail_vfx.play("default")
	boss_4.enrage_fire_pop.emitting = true
	dark_wind_vfx.play("default")

func stop_oblivion_vfx():
	oblivion_pass_dark_vfx.stop()
	oblivion_pass_gold_vfx.stop()
	oblivion_fail_vfx.stop()
	
func play_dark_wind_vfx():
	dark_wind_vfx.play("default")
	
func move_oblivion_collision_vfx():
	oblivion_pass_gold_vfx.global_position = spawn_clone.global_position
	oblivion_pass.global_position = spawn_clone.global_position
	

#///////////////////////////// - Cutscene functions
func change_to_cutscene_camera():
	cutscene_camera.make_current()
	GlobalCount.camera = cutscene_camera
	
func tween_boss_player():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, 50), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
	var tween_boss = get_tree().create_tween()
	tween_boss.tween_property(boss_cutscene_sprite, "position", boss_cutscene_sprite.position + Vector2(0, -50), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
		
func tween_push_player():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, 45), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)
func tween_player_walk():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -35), 1.5)
	
func player_walk_closer():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -10), 1)
	
func player_walk_to_boss():
	var tween_player = get_tree().create_tween()
	tween_player.tween_property(player_cutscene_sprite, "position", player_cutscene_sprite.position + Vector2(0, -25), 2)

func camera_shake_cutscene():
	GlobalCount.camera.apply_shake(25.0, 20.0)
	
func camera_shake_destroy_blade():
	GlobalCount.camera.apply_shake(0.7, 20.0, 4.0)

#func camera_shake_destroy_blade_2():
	#GlobalCount.camera.apply_shake(2.5, 20.0, 2.0)
	
func flash_screen():
	enrage_background.play("flash_screen")
	
func spawn_cleave():
	var cleave_spawn = cleave.instantiate()
	cleave_spawn.direction = 1
	cleave_spawn.position = player_cutscene_sprite.position + Vector2(0, 7)
	cleave_spawn.rotation = deg_to_rad(-90)
	cleave_spawn.player = player
	add_child(cleave_spawn)
	
func fade_black():
	TransitionScreen.transition_end_game()
	
func spawn_glass_shard():
	for i in range(75):
		var shard = glass_shard.instantiate()
		shard.origin = boss_cutscene_sprite.global_position
		add_child(shard)
	
func boss_tug_vfx():
	knockback_effect.play_backwards("default")
	
func play_light_anim():
	light_anim.play("default")
	
func change_stage_texture(stage: String):
	foreground_arena.texture = boss_stage_textures[stage]
	
# BOSS 0 FUNCTIONS
func invisible_attack_sound():
	invisible_attack_audio.play()
	
# BOSS 1 FUNCTIONS
func inout_alternate_audio():
	in_out_alternate_audio.play()
	
# BOSS 2 FUNCTIONS
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

func spawn_special_counterclockwise() -> void:
	range_line_first = ranged_special_initial_2.instantiate()
	add_child(range_line_first)
	
	await get_tree().create_timer(2.94).timeout
	for i in range(20):
		if boss_4.boss_death:
			break
		range_special_audio = ranged_audio.instantiate()
		add_child(range_special_audio)
		await get_tree().create_timer(0.5).timeout
		if boss_4.boss_death:
			break
	
func spawn_special_clockwise() -> void:
	range_line = ranged_special_2.instantiate()
	add_child(range_line)
	
	await get_tree().create_timer(2.94).timeout
	for i in range(20):
		if boss_4.boss_death:
			break
		range_special_audio = ranged_audio.instantiate()
		add_child(range_special_audio)
		await get_tree().create_timer(0.5).timeout
		if boss_4.boss_death:
			break
		
func turn_object_off():
	player.set_process(false)
	player.set_physics_process(false)
	boss_4.set_physics_process(false)

func turn_objects_on():
	GlobalCount.timer_active = true
	player.set_process(true)
	player.set_physics_process(true)
	boss_4.set_physics_process(true)

func tween_camera():
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "offset", Vector2(0, 0), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func phase_music():
	AudioPlayer.play_music(boss_music.stream, -30)
	
func white_left_vfx():
	white_bubble_left.play("white")
	white_wind_left.play("white")
	
func black_left_vfx():
	black_wind_left.play("black")
	black_bubble_left.play("black")
	
func white_right_vfx():
	white_bubble_right.play("white")
	white_wind_right.play("white")
	
func black_right_vfx():
	black_wind_right.play("black")
	black_bubble_right.play("black")
	
func ground_aura():
	ground_aura_1.play("default")
	await get_tree().create_timer(0.93).timeout
	ground_aura_2.play("default")
	
func play_white_sparkle():
	sparkle_burst.play("default")
	
func play_end_music():
	AudioPlayer.play_music(end_music.stream, -15)
	
