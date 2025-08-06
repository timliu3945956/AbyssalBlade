extends CenterContainer

@onready var player: CharacterBody2D = $Player
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var camera: Camera2D = $Player/Camera2D

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var in_out_alternate_audio: AudioStreamPlayer2D = $in_out_alternate_audio
@onready var top_down_audio: AudioStreamPlayer2D = $top_down_audio
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic
#@onready var boss_music = preload("res://audio/music/boss 1 music (loop-ready).wav")
@onready var smoke_top_1: AnimatedSprite2D = $InOutAttack/SmokeTop1
@onready var smoke_top_2: AnimatedSprite2D = $InOutAttack/SmokeTop2
@onready var smoke_bottom_1: AnimatedSprite2D = $InOutAttack/SmokeBottom1
@onready var smoke_bottom_2: AnimatedSprite2D = $InOutAttack/SmokeBottom2

@onready var out_attack_1: AnimatedSprite2D = $"InOutAttack/Telegraph1,1/Sprite2D/AnimatedSprite2D"
@onready var out_attack_2: AnimatedSprite2D = $"InOutAttack/Telegraph1,2/Sprite2D/AnimatedSprite2D"
@onready var out_attack_3: AnimatedSprite2D = $"InOutAttack/Telegraph1,3/Sprite2D/AnimatedSprite2D"
@onready var out_attack_4: AnimatedSprite2D = $"InOutAttack/Telegraph1,4/Sprite2D/AnimatedSprite2D"
@onready var out_attack_5: AnimatedSprite2D = $"InOutAttack/Telegraph2,1/Sprite2D/AnimatedSprite2D"
@onready var out_attack_6: AnimatedSprite2D = $"InOutAttack/Telegraph2,4/Sprite2D/AnimatedSprite2D"
@onready var out_attack_7: AnimatedSprite2D = $"InOutAttack/Telegraph3,1/Sprite2D/AnimatedSprite2D"
@onready var out_attack_8: AnimatedSprite2D = $"InOutAttack/Telegraph3,4/Sprite2D/AnimatedSprite2D"
@onready var out_attack_9: AnimatedSprite2D = $"InOutAttack/Telegraph4,1/Sprite2D/AnimatedSprite2D"
@onready var out_attack_10: AnimatedSprite2D = $"InOutAttack/Telegraph4,2/Sprite2D/AnimatedSprite2D"
@onready var out_attack_11: AnimatedSprite2D = $"InOutAttack/Telegraph4,3/Sprite2D/AnimatedSprite2D"
@onready var out_attack_12: AnimatedSprite2D = $"InOutAttack/Telegraph4,4/Sprite2D/AnimatedSprite2D"

@onready var in_attack_1: AnimatedSprite2D = $"InOutAttack/Telegraph2,2/Sprite2D/AnimatedSprite2D"
@onready var in_attack_2: AnimatedSprite2D = $"InOutAttack/Telegraph2,3/Sprite2D/AnimatedSprite2D"
@onready var in_attack_3: AnimatedSprite2D = $"InOutAttack/Telegraph3,2/Sprite2D/AnimatedSprite2D"
@onready var in_attack_4: AnimatedSprite2D = $"InOutAttack/Telegraph3,3/Sprite2D/AnimatedSprite2D"

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
@onready var arrow_marker: Marker2D = $ArrowMarker


@onready var in_out_attack: Area2D = $InOutAttack


@onready var cutscene_animation_player: AnimationPlayer = $CutsceneAnimationPlayer
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var camera_2d: Camera2D = $Player/Camera2D

@onready var static_outer_arena: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var phase_transition_audio: AudioStreamPlayer2D = $PhaseTransitionAudio


func _ready():
	static_outer_arena.disabled = true
	#if Global.player_data_slots[Global.current_slot_index].cutscene_viewed_boss_2 == false:
		#start_cutscene()
		#Global.player_data_slots[Global.current_slot_index].cutscene_viewed_boss_2 = true
		#Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
	
	AudioPlayer.stop_music()
	GlobalCount.reset_count()
	if GlobalCount.from_stage_select_enter:
		GlobalCount.from_stage_select_enter = false
		GlobalCount.paused = true
		player.set_process(false)
		player.set_physics_process(false)
		cutscene_player.play("new_animation")
		await cutscene_player.animation_finished
		player.set_process(true)
		player.set_physics_process(true)
		GlobalCount.paused = false
	GlobalCount.in_subtree_menu = false
	
func _process(delta):
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta
	
	#if GlobalCount.player_dead == true:
		#TransitionScreen.transition()
		#await TransitionScreen.on_transition_finished
		#get_tree().reload_current_scene()

func start_cutscene():
	#player.set_process_input(false)
	cutscene_camera.make_current()
	cutscene_animation_player.play("boss_intro")
	await cutscene_animation_player.animation_finished
	camera_2d.make_current()
	#player.set_process_input(true)
	
	#cutscene_camera.current = false
	

func inout_alternate_audio():
	in_out_alternate_audio.play()
	
func top_down_audio_play():
	top_down_audio.play()
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func top_smoke_play():
	smoke_top_1.play("smoke")
	smoke_top_2.play("smoke")
	
func bottom_smoke_play():
	smoke_bottom_1.play("smoke")
	smoke_bottom_2.play("smoke")
	
func in_attack_vfx():
	in_attack_1.play("default")
	in_attack_2.play("default")
	in_attack_3.play("default")
	in_attack_4.play("default")
	
func out_attack_vfx():
	out_attack_1.play("default")
	out_attack_2.play("default")
	out_attack_3.play("default")
	out_attack_4.play("default")
	out_attack_5.play("default")
	out_attack_6.play("default")
	out_attack_7.play("default")
	out_attack_8.play("default")
	out_attack_9.play("default")
	out_attack_10.play("default")
	out_attack_11.play("default")
	out_attack_12.play("default")

func reset_smoothing():
	camera.reset_smoothing()
