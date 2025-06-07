extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_animation_player: AnimationPlayer = $SpriteAnimationPlayer
@onready var icon_animation: AnimationPlayer = $IconAnimation

@onready var label: Label = $Label
@onready var icon_expand: Sprite2D = $IconExpand
@onready var area: Area2D = $Area2D
@onready var vfx_timer: Timer = $VFXTimer
@onready var top_bottom_attack_2: AnimatedSprite2D = $Area2D/CleaveVFX/TopBottomAttack2
@onready var animated_sprite_2d: AnimatedSprite2D = $Area2D/CleaveVFX/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $Area2D/CleaveVFX/AnimatedSprite2D2
@onready var sprite: Sprite2D = $Sprite2D
@onready var smoke: AnimatedSprite2D = $smoke

var darkness_balance_vfx = preload("res://Other/darkness_balance_vfx.tscn")
var tether = preload("res://Other/Tether.tscn")
var cleave = preload("res://Other/half_room_cleave.tscn")
#var numeral: String = ""
var index: int = -1

const ALL_NUMBER_TEXTURES = [
	preload("res://sprites/GriefBoss/premonition/premonition_1.png"),
	preload("res://sprites/GriefBoss/premonition/premonition_2.png"),
	preload("res://sprites/GriefBoss/premonition/premonition_3.png"),
	preload("res://sprites/GriefBoss/premonition/premonition_4.png")
]
var player: CharacterBody2D
var boss: CharacterBody2D
var tether_instance: Node
var tween: Tween
var sprite_tween: Tween
var label_tween: Tween
var spawn_vfx
var sprite_direction: String

func _ready():
	self.modulate.a = 0
	smoke.rotation = randf_range(0.0, TAU)
	#sprite.material("shader_parameter/fade_alpha") = 0
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property(sprite.material, "shader_parameter/fade_alpha", 0.7, 0.5)
	tether_vfx()

func set_index(i: int) -> void:
	index = clamp(i, 0, ALL_NUMBER_TEXTURES.size() - 1)
	#numeral = n
	#label.text = n
	var sb := StyleBoxTexture.new()
	sb.texture = ALL_NUMBER_TEXTURES[index]
	label.add_theme_stylebox_override("normal", sb)
	icon_expand.texture = ALL_NUMBER_TEXTURES[index]
	_pick_idle_anim()
	
func _on_boss_clone_telegraph(idx_from_boss : int) -> void:
	if idx_from_boss == index:
		tether_stop()
		area.rotation = area.global_position.angle_to_point(player.global_position)
		vfx_timer.stop()
		animation_player.play("telegraph")
		_pick_cleave_anim()
		icon_animation.play("icon_blink")

func _on_boss_clones_attack() -> void:
	perform_attack()
	
func perform_attack() -> void:
	#top_bottom_attack_2.play("default")
	#animated_sprite_2d.play("default")
	#animated_sprite_2d_2.play("default")
	#animation_player.play("attack")
	add_cleave_vfx()
	_pick_cleave_finish()
	await get_tree().create_timer(0.5).timeout
	_pick_idle_anim()
	await get_tree().create_timer(0.5).timeout
	
	#await animated_sprite_2d.animation_finished
	smoke.play("smoke")
	sprite.visible = false
	#tween = get_tree().create_tween()
	#tween.tween_property(sprite, "modulate:a", 0, 0.3)
	
	await get_tree().create_timer(0.3).timeout
	queue_free()
	
func add_cleave_vfx():
	var cleave_vfx = cleave.instantiate()
	area.add_child(cleave_vfx)

func tether_vfx():
	tether_vfx_spawn()
	vfx_timer.start()
	spawn_tether()
	#player.tether_vfx_spawn()
	#player.vfx_timer.start()

func tether_stop():
	#vfx_timer.stop()
	if is_instance_valid(tether_instance):
		tether_instance.queue_free()
	#player.vfx_timer.stop()

func spawn_tether():
	tether_instance = tether.instantiate()
	tether_instance.player = player
	#tether_instance.position = Vector2(0, -8)
	tether_instance.set_timer = 30.0
	add_child(tether_instance)

func tether_vfx_spawn():
	spawn_vfx = darkness_balance_vfx.instantiate()
	spawn_vfx.position = Vector2(0, -8)
	add_child(spawn_vfx)


func _on_vfx_timer_timeout() -> void:
	tether_vfx_spawn()
	
func _pick_idle_anim():
	var to_boss : Vector2 = (boss.global_position - global_position).normalized()
	if abs(to_boss.x) > abs(to_boss.y):
		if to_boss.x > 0.0:
			sprite_animation_player.play("idle_right")
		else:
			sprite_animation_player.play("idle_left")
	else:
		if to_boss.y > 0.0:
			sprite_animation_player.play("idle_down")
		else:
			sprite_animation_player.play("idle_up")

func _pick_cleave_anim():
	var to_player : Vector2 = (player.global_position - global_position).normalized()
	
	if abs(to_player.x) > abs(to_player.y):
		if to_player.x > 0.0:
			sprite_animation_player.play("cleave_start_right")
			sprite_direction = "right"
		else:
			sprite_animation_player.play("cleave_start_left")
			sprite_direction = "left"
	else:
		if to_player.y > 0.0:
			sprite_animation_player.play("cleave_start_down")
			sprite_direction = "down"
		else:
			sprite_animation_player.play("cleave_start_up")
			sprite_direction = "up"

func _pick_cleave_finish():
	match sprite_direction:
		"up":
			sprite_animation_player.play("cleave_finish_up")
		"down":
			sprite_animation_player.play("cleave_finish_down")
		"left":
			sprite_animation_player.play("cleave_finish_left")
		"right":
			sprite_animation_player.play("cleave_finish_right")
