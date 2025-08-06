extends Area2D

@export var fade_speed = 3.0

@onready var collision_: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var timer: Timer = $Timer
var boss

func _ready():
	boss.boss_died.connect(_on_boss_died)
	animation_player.play("circle attack")
	animated_sprite_2d.play("new_animation")
	timer.start()
	#sprite.self_modulate.a * 0.9
	#await get_tree().create_timer(0.5).timeout
	#queue_free()

func _process(delta):
	await get_tree().create_timer(7).timeout
	self.modulate.a = max(0, self.modulate.a - delta * fade_speed)
	await get_tree().create_timer(0.3).timeout
	queue_free()
#func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#print("circle is now gone")
	#queue_free()


func _on_timer_timeout() -> void:
	animated_sprite_2d_2.play("new_animation")
	
func _on_boss_died():
	queue_free()
