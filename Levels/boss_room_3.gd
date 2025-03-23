extends CenterContainer

@onready var top_left_blood: AnimatedSprite2D = $BarrageVFX/TopLeft/TopLeftBlood
@onready var top_right_blood: AnimatedSprite2D = $BarrageVFX/TopRight2/TopRightBlood
@onready var bot_left_blood: AnimatedSprite2D = $BarrageVFX/BottomLeft/BotLeftBlood
@onready var bot_right_blood: AnimatedSprite2D = $BarrageVFX/BottomRight/BotRightBlood
@onready var middle_blood: AnimatedSprite2D = $"BarrageVFX/Barrage+/BloodVFX/MiddleBlood"
@onready var top_blood: AnimatedSprite2D = $"BarrageVFX/Barrage+/BloodVFX/TopBlood"
@onready var left_blood: AnimatedSprite2D = $"BarrageVFX/Barrage+/BloodVFX/LeftBlood"
@onready var right_blood: AnimatedSprite2D = $"BarrageVFX/Barrage+/BloodVFX/RightBlood"
@onready var bottom_blood: AnimatedSprite2D = $"BarrageVFX/Barrage+/BloodVFX/BottomBlood"

@onready var top_left_blood_white: AnimatedSprite2D = $BarrageOppositeWhiteVFX/TopLeft/TopLeftBlood
@onready var top_right_blood_white: AnimatedSprite2D = $BarrageOppositeWhiteVFX/TopRight/TopRightBlood
@onready var bot_left_blood_white: AnimatedSprite2D = $BarrageOppositeWhiteVFX/BottomLeft/BottomLeftBlood
@onready var bot_right_blood_white: AnimatedSprite2D = $BarrageOppositeWhiteVFX/BottomRight/BottomRightBlood
@onready var middle_blood_white: AnimatedSprite2D = $"BarrageOppositeWhiteVFX/Barrage+/BloodVFX/MiddleBlood"
@onready var top_blood_white: AnimatedSprite2D = $"BarrageOppositeWhiteVFX/Barrage+/BloodVFX/TopBlood"
@onready var left_blood_white: AnimatedSprite2D = $"BarrageOppositeWhiteVFX/Barrage+/BloodVFX/LeftBlood"
@onready var right_blood_white: AnimatedSprite2D = $"BarrageOppositeWhiteVFX/Barrage+/BloodVFX/RightBlood"
@onready var bottom_blood_white: AnimatedSprite2D = $"BarrageOppositeWhiteVFX/Barrage+/BloodVFX/BottomBlood"

@onready var top_left_blood_black: AnimatedSprite2D = $BarrageOppositeBlackVFX/TopLeft/TopLeftBlood
@onready var top_right_blood_black: AnimatedSprite2D = $BarrageOppositeBlackVFX/TopRight/TopRightBlood
@onready var bot_left_blood_black: AnimatedSprite2D = $BarrageOppositeBlackVFX/BottomLeft/BottomLeftBlood
@onready var bot_right_blood_black: AnimatedSprite2D = $BarrageOppositeBlackVFX/BottomRight/BottomRightBlood
@onready var middle_blood_black: AnimatedSprite2D = $"BarrageOppositeBlackVFX/Barrage+/BloodVFX/MiddleBlood"
@onready var top_blood_black: AnimatedSprite2D = $"BarrageOppositeBlackVFX/Barrage+/BloodVFX/TopBlood"
@onready var left_blood_black: AnimatedSprite2D = $"BarrageOppositeBlackVFX/Barrage+/BloodVFX/LeftBlood"
@onready var right_blood_black: AnimatedSprite2D = $"BarrageOppositeBlackVFX/Barrage+/BloodVFX/RightBlood"
@onready var bottom_blood_black: AnimatedSprite2D = $"BarrageOppositeBlackVFX/Barrage+/BloodVFX/BottomBlood"

@onready var oppressive_area_left: Area2D = $OppressiveAreaLeft
@onready var oppressive_area_right: Area2D = $OppressiveAreaRight

@onready var black_bubble_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/BlackBubble
@onready var white_bubble_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/WhiteBubble
@onready var black_wind_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/BlackWind
@onready var white_wind_left: AnimatedSprite2D = $OppressiveVFX/OppressiveLeft/WhiteWind
@onready var white_particles_left: GPUParticles2D = $OppressiveVFX/OppressiveLeft/WhiteParticles
@onready var black_particles_left: GPUParticles2D = $OppressiveVFX/OppressiveLeft/BlackParticles

@onready var black_bubble_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/BlackBubble
@onready var white_bubble_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/WhiteBubble
@onready var black_wind_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/BlackWind
@onready var white_wind_right: AnimatedSprite2D = $OppressiveVFX/OppressiveRight/WhiteWind
@onready var white_particles_right: GPUParticles2D = $OppressiveVFX/OppressiveRight/WhiteParticles
@onready var black_particles_right: GPUParticles2D = $OppressiveVFX/OppressiveRight/BlackParticles


@onready var white_telegraph_left: Node2D = $OppressiveVFX/WhiteTelegraphLeft
@onready var white_telegraph_particles_1: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles1
@onready var white_telegraph_particles_2: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles2
@onready var white_telegraph_particles_3: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles3
@onready var white_telegraph_particles_4: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles4
@onready var white_telegraph_particles_5: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles5
@onready var white_telegraph_particles_6: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles6
@onready var white_telegraph_particles_7: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles7
@onready var white_telegraph_particles_8: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphLeft/WhiteTelegraphParticles8
@onready var black_telegraph_right: Node2D = $OppressiveVFX/BlackTelegraphRight
@onready var black_telegraph_particles_1: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles1
@onready var black_telegraph_particles_2: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles2
@onready var black_telegraph_particles_3: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles3
@onready var black_telegraph_particles_4: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles4
@onready var black_telegraph_particles_5: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles5
@onready var black_telegraph_particles_6: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles6
@onready var black_telegraph_particles_7: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles7
@onready var black_telegraph_particles_8: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphRight/BlackTelegraphParticles8

@onready var white_telegraph_right: Node2D = $OppressiveVFX/WhiteTelegraphRight
@onready var white_right_telegraph_particles_1: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles1
@onready var white_right_telegraph_particles_2: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles2
@onready var white_right_telegraph_particles_3: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles3
@onready var white_right_telegraph_particles_4: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles4
@onready var white_right_telegraph_particles_5: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles5
@onready var white_right_telegraph_particles_6: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles6
@onready var white_right_telegraph_particles_7: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles7
@onready var white_right_telegraph_particles_8: AnimatedSprite2D = $OppressiveVFX/WhiteTelegraphRight/WhiteTelegraphParticles8
@onready var black_telegraph_left: Node2D = $OppressiveVFX/BlackTelegraphLeft
@onready var black_left_telegraph_particles_1: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles1
@onready var black_left_telegraph_particles_2: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles2
@onready var black_left_telegraph_particles_3: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles3
@onready var black_left_telegraph_particles_4: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles4
@onready var black_left_telegraph_particles_5: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles5
@onready var black_left_telegraph_particles_6: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles6
@onready var black_left_telegraph_particles_7: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles7
@onready var black_left_telegraph_particles_8: AnimatedSprite2D = $OppressiveVFX/BlackTelegraphLeft/BlackTelegraphParticles8


#devour circle anim + circle pulse
@onready var ground_aura_1: AnimatedSprite2D = $Devour/DevourCircle/GroundAura1
@onready var ground_aura_2: AnimatedSprite2D = $Devour/DevourCircle/GroundAura2
@onready var point_light: PointLight2D = $Devour/DevourCircle/PointLight2D
@onready var devour_circle_collision: CollisionPolygon2D = $Devour/DevourCircleArea2D/DevourCircleCollision
@onready var devour_circle_animation: AnimationPlayer = $Devour/DevourCircleAnimation


var oppressive_left: String
var oppressive_right: String
#var tween_left_particle_1 = get_tree().create_tween()
#var tween_left_particle_2 = get_tree().create_tween()
#var tween_left_particle_3 = get_tree().create_tween()
#var tween_left_particle_4 = get_tree().create_tween()
#var tween_left_particle_5 = get_tree().create_tween()
#var tween_left_particle_6 = get_tree().create_tween()
#var tween_left_particle_7 = get_tree().create_tween()
#var tween_left_particle_8 = get_tree().create_tween()
#var tween_right_particle_1 = get_tree().create_tween()
#var tween_right_particle_2 = get_tree().create_tween()
#var tween_right_particle_3 = get_tree().create_tween()
#var tween_right_particle_4 = get_tree().create_tween()
#var tween_right_particle_5 = get_tree().create_tween()
#var tween_right_particle_6 = get_tree().create_tween()
#var tween_right_particle_7 = get_tree().create_tween()
#var tween_right_particle_8 = get_tree().create_tween()

func _ready() -> void:
	AudioPlayer.stop_music()
	GlobalCount.reset_count()
	
	devour_circle_collision.disabled = true
	ground_aura_1.modulate.a = 0
	ground_aura_2.modulate.a = 0
	point_light.color.a = 0
	white_telegraph_particles_1.modulate.a = 0
	white_telegraph_particles_2.modulate.a = 0
	white_telegraph_particles_3.modulate.a = 0
	white_telegraph_particles_4.modulate.a = 0
	white_telegraph_particles_5.modulate.a = 0
	white_telegraph_particles_6.modulate.a = 0
	white_telegraph_particles_7.modulate.a = 0
	white_telegraph_particles_8.modulate.a = 0
	black_telegraph_particles_1.modulate.a = 0
	black_telegraph_particles_2.modulate.a = 0
	black_telegraph_particles_3.modulate.a = 0
	black_telegraph_particles_4.modulate.a = 0
	black_telegraph_particles_5.modulate.a = 0
	black_telegraph_particles_6.modulate.a = 0
	black_telegraph_particles_7.modulate.a = 0
	black_telegraph_particles_8.modulate.a = 0
	white_right_telegraph_particles_1.modulate.a = 0
	white_right_telegraph_particles_2.modulate.a = 0
	white_right_telegraph_particles_3.modulate.a = 0
	white_right_telegraph_particles_4.modulate.a = 0
	white_right_telegraph_particles_5.modulate.a = 0
	white_right_telegraph_particles_6.modulate.a = 0
	white_right_telegraph_particles_7.modulate.a = 0
	white_right_telegraph_particles_8.modulate.a = 0
	black_left_telegraph_particles_1.modulate.a = 0
	black_left_telegraph_particles_2.modulate.a = 0
	black_left_telegraph_particles_3.modulate.a = 0
	black_left_telegraph_particles_4.modulate.a = 0
	black_left_telegraph_particles_5.modulate.a = 0
	black_left_telegraph_particles_6.modulate.a = 0
	black_left_telegraph_particles_7.modulate.a = 0
	black_left_telegraph_particles_8.modulate.a = 0

func _process(delta: float) -> void:
	if GlobalCount.timer_active:
		GlobalCount.elapsed_time += delta

func camera_shake():
	GlobalCount.camera.apply_shake(1.5, 15.0)
	
func camera_shake_phase_2():
	GlobalCount.camera.apply_shake(5, 25.0)

func top_left_vfx():
	top_left_blood.play("default")

func top_right_vfx():
	top_right_blood.play("default")
	
func bot_left_vfx():
	bot_left_blood.play("default")
	
func bot_right_vfx():
	bot_right_blood.play("default")

func middle_vfx():
	middle_blood.play("default")

func top_vfx():
	top_blood.play("default")
	
func left_vfx():
	left_blood.play("default")

func right_vfx():
	right_blood.play("default")

func bottom_vfx():
	bottom_blood.play("default")
	
func top_left_white_vfx():
	top_left_blood_white.play("default")

func top_right_white_vfx():
	top_right_blood_white.play("default")
	
func bot_left_white_vfx():
	bot_left_blood_white.play("default")
	
func bot_right_white_vfx():
	bot_right_blood_white.play("default")

func middle_white_vfx():
	middle_blood_white.play("default")

func top_white_vfx():
	top_blood_white.play("default")
	
func left_white_vfx():
	left_blood_white.play("default")

func right_white_vfx():
	right_blood_white.play("default")

func bottom_white_vfx():
	bottom_blood_white.play("default")
	
func top_left_black_vfx():
	top_left_blood_black.play("default")

func top_right_black_vfx():
	top_right_blood_black.play("default")
	
func bot_left_black_vfx():
	bot_left_blood_black.play("default")
	
func bot_right_black_vfx():
	bot_right_blood_black.play("default")

func middle_black_vfx():
	middle_blood_black.play("default")

func top_black_vfx():
	top_blood_black.play("default")
	
func left_black_vfx():
	left_blood_black.play("default")

func right_black_vfx():
	right_blood_black.play("default")

func bottom_black_vfx():
	bottom_blood_black.play("default")

	
func ground_aura():
	var aura_tween_1 = get_tree().create_tween()
	var aura_tween_2 = get_tree().create_tween()
	var light_tween = get_tree().create_tween()
	ground_aura_1.play("default")
	aura_tween_1.tween_property(point_light, "color:a", 1.0, 0.5)
	aura_tween_2.tween_property(ground_aura_1, "modulate:a", 1.0, 0.5)
	light_tween.tween_property(ground_aura_2, "modulate:a", 1.0, 0.5)
	
	await get_tree().create_timer(0.93).timeout
	devour_circle_animation.play("circle_pulse")
	devour_circle_collision.disabled = false
	ground_aura_2.play("default")
	
func ground_aura_end():
	var aura_tween_1 = get_tree().create_tween()
	var aura_tween_2 = get_tree().create_tween()
	var light_tween = get_tree().create_tween()
	devour_circle_collision.disabled = true
	aura_tween_1.tween_property(point_light, "color:a", 0, 0.5)
	aura_tween_2.tween_property(ground_aura_1, "modulate:a", 0, 0.5)
	light_tween.tween_property(ground_aura_2, "modulate:a", 0, 0.5)
	devour_circle_animation.stop()
	
func black_left_vfx():
	black_bubble_left.play("black")
	black_wind_left.play("black")
	
func white_left_vfx():
	white_bubble_left.play("white")
	white_wind_left.play("white")
	
func black_right_vfx():
	black_bubble_right.play("black")
	black_wind_right.play("black")

func white_right_vfx():
	white_bubble_right.play("white")
	white_wind_right.play("white")
	
func white_black_telegraph_start():
	var tween_left_particle_1 = get_tree().create_tween()
	var tween_left_particle_2 = get_tree().create_tween()
	var tween_left_particle_3 = get_tree().create_tween()
	var tween_left_particle_4 = get_tree().create_tween()
	var tween_left_particle_5 = get_tree().create_tween()
	var tween_left_particle_6 = get_tree().create_tween()
	var tween_left_particle_7 = get_tree().create_tween()
	var tween_left_particle_8 = get_tree().create_tween()
	var tween_right_particle_1 = get_tree().create_tween()
	var tween_right_particle_2 = get_tree().create_tween()
	var tween_right_particle_3 = get_tree().create_tween()
	var tween_right_particle_4 = get_tree().create_tween()
	var tween_right_particle_5 = get_tree().create_tween()
	var tween_right_particle_6 = get_tree().create_tween()
	var tween_right_particle_7 = get_tree().create_tween()
	var tween_right_particle_8 = get_tree().create_tween()
	tween_left_particle_1.tween_property(white_telegraph_particles_1, "modulate:a", 1, 0.5)
	tween_left_particle_2.tween_property(white_telegraph_particles_2, "modulate:a", 1, 0.5)
	tween_left_particle_3.tween_property(white_telegraph_particles_3, "modulate:a", 1, 0.5)
	tween_left_particle_4.tween_property(white_telegraph_particles_4, "modulate:a", 1, 0.5)
	tween_left_particle_5.tween_property(white_telegraph_particles_5, "modulate:a", 1, 0.5)
	tween_left_particle_6.tween_property(white_telegraph_particles_6, "modulate:a", 1, 0.5)
	tween_left_particle_7.tween_property(white_telegraph_particles_7, "modulate:a", 1, 0.5)
	tween_left_particle_8.tween_property(white_telegraph_particles_8, "modulate:a", 1, 0.5)
	
	tween_right_particle_1.tween_property(black_telegraph_particles_1, "modulate:a", 1, 0.5)
	tween_right_particle_2.tween_property(black_telegraph_particles_2, "modulate:a", 1, 0.5)
	tween_right_particle_3.tween_property(black_telegraph_particles_3, "modulate:a", 1, 0.5)
	tween_right_particle_4.tween_property(black_telegraph_particles_4, "modulate:a", 1, 0.5)
	tween_right_particle_5.tween_property(black_telegraph_particles_5, "modulate:a", 1, 0.5)
	tween_right_particle_6.tween_property(black_telegraph_particles_6, "modulate:a", 1, 0.5)
	tween_right_particle_7.tween_property(black_telegraph_particles_7, "modulate:a", 1, 0.5)
	tween_right_particle_8.tween_property(black_telegraph_particles_8, "modulate:a", 1, 0.5)
	
func white_black_telegraph_end():
	var tween_left_particle_1 = get_tree().create_tween()
	var tween_left_particle_2 = get_tree().create_tween()
	var tween_left_particle_3 = get_tree().create_tween()
	var tween_left_particle_4 = get_tree().create_tween()
	var tween_left_particle_5 = get_tree().create_tween()
	var tween_left_particle_6 = get_tree().create_tween()
	var tween_left_particle_7 = get_tree().create_tween()
	var tween_left_particle_8 = get_tree().create_tween()
	var tween_right_particle_1 = get_tree().create_tween()
	var tween_right_particle_2 = get_tree().create_tween()
	var tween_right_particle_3 = get_tree().create_tween()
	var tween_right_particle_4 = get_tree().create_tween()
	var tween_right_particle_5 = get_tree().create_tween()
	var tween_right_particle_6 = get_tree().create_tween()
	var tween_right_particle_7 = get_tree().create_tween()
	var tween_right_particle_8 = get_tree().create_tween()
	tween_left_particle_1.tween_property(white_telegraph_particles_1, "modulate:a", 0, 0.5)
	tween_left_particle_2.tween_property(white_telegraph_particles_2, "modulate:a", 0, 0.5)
	tween_left_particle_3.tween_property(white_telegraph_particles_3, "modulate:a", 0, 0.5)
	tween_left_particle_4.tween_property(white_telegraph_particles_4, "modulate:a", 0, 0.5)
	tween_left_particle_5.tween_property(white_telegraph_particles_5, "modulate:a", 0, 0.5)
	tween_left_particle_6.tween_property(white_telegraph_particles_6, "modulate:a", 0, 0.5)
	tween_left_particle_7.tween_property(white_telegraph_particles_7, "modulate:a", 0, 0.5)
	tween_left_particle_8.tween_property(white_telegraph_particles_8, "modulate:a", 0, 0.5)
	
	tween_right_particle_1.tween_property(black_telegraph_particles_1, "modulate:a", 0, 0.5)
	tween_right_particle_2.tween_property(black_telegraph_particles_2, "modulate:a", 0, 0.5)
	tween_right_particle_3.tween_property(black_telegraph_particles_3, "modulate:a", 0, 0.5)
	tween_right_particle_4.tween_property(black_telegraph_particles_4, "modulate:a", 0, 0.5)
	tween_right_particle_5.tween_property(black_telegraph_particles_5, "modulate:a", 0, 0.5)
	tween_right_particle_6.tween_property(black_telegraph_particles_6, "modulate:a", 0, 0.5)
	tween_right_particle_7.tween_property(black_telegraph_particles_7, "modulate:a", 0, 0.5)
	tween_right_particle_8.tween_property(black_telegraph_particles_8, "modulate:a", 0, 0.5)

func black_white_telegraph_start():
	var tween_left_particle_1 = get_tree().create_tween()
	var tween_left_particle_2 = get_tree().create_tween()
	var tween_left_particle_3 = get_tree().create_tween()
	var tween_left_particle_4 = get_tree().create_tween()
	var tween_left_particle_5 = get_tree().create_tween()
	var tween_left_particle_6 = get_tree().create_tween()
	var tween_left_particle_7 = get_tree().create_tween()
	var tween_left_particle_8 = get_tree().create_tween()
	var tween_right_particle_1 = get_tree().create_tween()
	var tween_right_particle_2 = get_tree().create_tween()
	var tween_right_particle_3 = get_tree().create_tween()
	var tween_right_particle_4 = get_tree().create_tween()
	var tween_right_particle_5 = get_tree().create_tween()
	var tween_right_particle_6 = get_tree().create_tween()
	var tween_right_particle_7 = get_tree().create_tween()
	var tween_right_particle_8 = get_tree().create_tween()
	tween_left_particle_1.tween_property(white_right_telegraph_particles_1, "modulate:a", 1, 0.5)
	tween_left_particle_2.tween_property(white_right_telegraph_particles_2, "modulate:a", 1, 0.5)
	tween_left_particle_3.tween_property(white_right_telegraph_particles_3, "modulate:a", 1, 0.5)
	tween_left_particle_4.tween_property(white_right_telegraph_particles_4, "modulate:a", 1, 0.5)
	tween_left_particle_5.tween_property(white_right_telegraph_particles_5, "modulate:a", 1, 0.5)
	tween_left_particle_6.tween_property(white_right_telegraph_particles_6, "modulate:a", 1, 0.5)
	tween_left_particle_7.tween_property(white_right_telegraph_particles_7, "modulate:a", 1, 0.5)
	tween_left_particle_8.tween_property(white_right_telegraph_particles_8, "modulate:a", 1, 0.5)
	
	tween_right_particle_1.tween_property(black_left_telegraph_particles_1, "modulate:a", 1, 0.5)
	tween_right_particle_2.tween_property(black_left_telegraph_particles_2, "modulate:a", 1, 0.5)
	tween_right_particle_3.tween_property(black_left_telegraph_particles_3, "modulate:a", 1, 0.5)
	tween_right_particle_4.tween_property(black_left_telegraph_particles_4, "modulate:a", 1, 0.5)
	tween_right_particle_5.tween_property(black_left_telegraph_particles_5, "modulate:a", 1, 0.5)
	tween_right_particle_6.tween_property(black_left_telegraph_particles_6, "modulate:a", 1, 0.5)
	tween_right_particle_7.tween_property(black_left_telegraph_particles_7, "modulate:a", 1, 0.5)
	tween_right_particle_8.tween_property(black_left_telegraph_particles_8, "modulate:a", 1, 0.5)
	
func black_white_telegraph_end():
	var tween_left_particle_1 = get_tree().create_tween()
	var tween_left_particle_2 = get_tree().create_tween()
	var tween_left_particle_3 = get_tree().create_tween()
	var tween_left_particle_4 = get_tree().create_tween()
	var tween_left_particle_5 = get_tree().create_tween()
	var tween_left_particle_6 = get_tree().create_tween()
	var tween_left_particle_7 = get_tree().create_tween()
	var tween_left_particle_8 = get_tree().create_tween()
	var tween_right_particle_1 = get_tree().create_tween()
	var tween_right_particle_2 = get_tree().create_tween()
	var tween_right_particle_3 = get_tree().create_tween()
	var tween_right_particle_4 = get_tree().create_tween()
	var tween_right_particle_5 = get_tree().create_tween()
	var tween_right_particle_6 = get_tree().create_tween()
	var tween_right_particle_7 = get_tree().create_tween()
	var tween_right_particle_8 = get_tree().create_tween()
	tween_left_particle_1.tween_property(white_right_telegraph_particles_1, "modulate:a", 0, 0.5)
	tween_left_particle_2.tween_property(white_right_telegraph_particles_2, "modulate:a", 0, 0.5)
	tween_left_particle_3.tween_property(white_right_telegraph_particles_3, "modulate:a", 0, 0.5)
	tween_left_particle_4.tween_property(white_right_telegraph_particles_4, "modulate:a", 0, 0.5)
	tween_left_particle_5.tween_property(white_right_telegraph_particles_5, "modulate:a", 0, 0.5)
	tween_left_particle_6.tween_property(white_right_telegraph_particles_6, "modulate:a", 0, 0.5)
	tween_left_particle_7.tween_property(white_right_telegraph_particles_7, "modulate:a", 0, 0.5)
	tween_left_particle_8.tween_property(white_right_telegraph_particles_8, "modulate:a", 0, 0.5)
	
	tween_right_particle_1.tween_property(black_left_telegraph_particles_1, "modulate:a", 0, 0.5)
	tween_right_particle_2.tween_property(black_left_telegraph_particles_2, "modulate:a", 0, 0.5)
	tween_right_particle_3.tween_property(black_left_telegraph_particles_3, "modulate:a", 0, 0.5)
	tween_right_particle_4.tween_property(black_left_telegraph_particles_4, "modulate:a", 0, 0.5)
	tween_right_particle_5.tween_property(black_left_telegraph_particles_5, "modulate:a", 0, 0.5)
	tween_right_particle_6.tween_property(black_left_telegraph_particles_6, "modulate:a", 0, 0.5)
	tween_right_particle_7.tween_property(black_left_telegraph_particles_7, "modulate:a", 0, 0.5)
	tween_right_particle_8.tween_property(black_left_telegraph_particles_8, "modulate:a", 0, 0.5)
