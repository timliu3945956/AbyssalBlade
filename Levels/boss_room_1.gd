extends CenterContainer

@onready var player: CharacterBody2D = $Player

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

@onready var cutscene_animation_player: AnimationPlayer = $CutsceneAnimationPlayer
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var camera_2d: Camera2D = $Player/Camera2D

func _ready():
	#if Global.player_data.cutscene_viewed_boss_2 == false:
		#start_cutscene()
		#Global.player_data.cutscene_viewed_boss_2 = true
		#Global.save_data(Global.SAVE_DIR + Global.SAVE_FILE_NAME)
	
	AudioPlayer.stop_music()
	GlobalCount.reset_count()
	
func _process(delta):
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta
	
	#if GlobalCount.player_dead == true:
		#TransitionScreen.transition()
		#await TransitionScreen.on_transition_finished
		#get_tree().reload_current_scene()

func start_cutscene():
	player.set_process_input(false)
	player.set_physics_process(false)
	cutscene_camera.make_current()
	cutscene_animation_player.play("boss_intro")
	await cutscene_animation_player.animation_finished
	camera_2d.make_current()
	player.set_process_input(true)
	player.set_physics_process(true)
	
	#cutscene_camera.current = false
	

func inout_alternate_audio():
	in_out_alternate_audio.play()
	
func top_down_audio_play():
	top_down_audio.play()
	
func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
func top_smoke_play():
	smoke_top_1.play("smoke")
	smoke_top_2.play("smoke")
	
func bottom_smoke_play():
	smoke_bottom_1.play("smoke")
	smoke_bottom_2.play("smoke")
