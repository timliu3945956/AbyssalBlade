extends CenterContainer

@onready var player: CharacterBody2D = $Player
@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var camera: Camera2D = $Player/Camera2D

@onready var top_bottom_attack: AnimatedSprite2D = $ForegroundArena/VHRotation/TopBottomAttack/TopBottomAttack
@onready var top_bottom_attack_2: AnimatedSprite2D = $ForegroundArena/VHRotation/TopBottomAttack/TopBottomAttack2

@onready var nsew_attack: AnimatedSprite2D = $ForegroundArena/NSEWRotation/NSEWAttack/NSEWAttack
@onready var nsew_attack_2: AnimatedSprite2D = $ForegroundArena/NSEWRotation/NSEWAttack/NSEWAttack2
@onready var aoe_vh_particles: GPUParticles2D = $ForegroundArena/VHRotation/TopBottomAttack/AOEParticles
@onready var aoe_nsew_particles: GPUParticles2D = $ForegroundArena/NSEWRotation/NSEWAttack/AOEParticles

@onready var arena_attack: AnimatedSprite2D = $ForegroundArena/Sprite2D/ArenaAttack
@onready var arena_attack_2: AnimatedSprite2D = $ForegroundArena/Sprite2D/ArenaAttack2
@onready var aoe_particles: GPUParticles2D = $ForegroundArena/Sprite2D/AOEParticles
@onready var area_attacks: Area2D = $AreaAttacks
@onready var cleave_clone_ysort_left: CharacterBody2D = $CleaveCloneYsortLeft
@onready var cleave_clone_y_sort_right: CharacterBody2D = $CleaveCloneYSortRight
@onready var summon_clone_particle_left: GPUParticles2D = $SummonCloneParticleLeft
@onready var summon_clone_particle_right: GPUParticles2D = $SummonCloneParticleRight

@onready var cleave_audio: AudioStreamPlayer2D = $cleave_audio
@onready var generate_audio: AudioStreamPlayer2D = $generate_audio
#@onready var sac_mech_fail_audio: AudioStreamPlayer2D = $sac_mech_fail_audio
@onready var invisible_attack_audio: AudioStreamPlayer2D = $invisible_attack_audio

@onready var boss_music: AudioStreamPlayer2D = $BackgroundMusic

@onready var cutscene_animation_player: AnimationPlayer = $CutsceneAnimationPlayer
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var camera_2d: Camera2D = $Player/Camera2D

@onready var static_outer_arena: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

func _ready() -> void:
	static_outer_arena.disabled = true
	AudioPlayer.stop_music()
	GlobalCount.reset_count()
	if GlobalCount.from_stage_select_enter:
		GlobalCount.from_stage_select_enter = false
		player.set_process(false)
		player.set_physics_process(false)
		GlobalCount.paused = true
		cutscene_player.play("new_animation")
		await cutscene_player.animation_finished
		player.set_process(true)
		player.set_physics_process(true)
		GlobalCount.paused = false
	GlobalCount.in_subtree_menu = false
		
func _process(delta: float) -> void:
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta

func enable_collision():
	static_outer_arena.set_deferred("disabled", false)
	print("this is the current state of static body collision: ", static_outer_arena.disabled)
	

func start_cutscene():
	cutscene_camera.make_current()
	cutscene_animation_player.play("boss_intro")
	await cutscene_animation_player.animation_finished
	camera_2d.make_current()
	

func top_bottom_cleave():
	aoe_vh_particles.emitting = true
	top_bottom_attack.play("new_animation")
	top_bottom_attack_2.play("default")
	
func ns_ew_cleave():
	aoe_nsew_particles.emitting = true
	nsew_attack.play("default")
	nsew_attack_2.play("default")
	
func trigger_wipe():
	aoe_particles.emitting = true
	arena_attack.play("default")
	arena_attack_2.play("default")
	
func cleave_sound():
	cleave_audio.play()
	
func generate_sound():
	generate_audio.play()
	
#func sac_mech_fail_sound():
	#sac_mech_fail_audio.play()
	
func invisible_attack_sound():
	invisible_attack_audio.play()
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
	
func camera_shake_phase_2():
	GlobalCount.camera.apply_shake(5, 25.0)

func reset_smoothing():
	camera.reset_smoothing()
