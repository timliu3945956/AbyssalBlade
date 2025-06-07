extends Node2D

@onready var start_vfx: AnimatedSprite2D = $StartVFX
@onready var center_orb: AnimatedSprite2D = $CenterOrb
@onready var orbs: AnimatedSprite2D = $Orbs
@onready var orbs_2: AnimatedSprite2D = $Orbs2

@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

func _ready():
	center_orb.visible = false
	orbs.visible = false
	orbs_2.visible = false
	start_vfx.play("default")
	timer.start()
	timer_2.start()

func _on_timer_timeout() -> void:
	center_orb.visible = true
	orbs.visible = true
	orbs_2.visible = true
	center_orb.play("default")
	orbs.play("default")
	orbs_2.play("default")

func _on_orbs_animation_looped() -> void:
	orbs.rotation = randf() * 360

func _on_orbs_2_animation_looped() -> void:
	orbs_2.rotation = randf() * 360

func _on_timer_2_timeout() -> void:
	var center_orb_tween = get_tree().create_tween()
	var orbs_tween = get_tree().create_tween()
	var orbs_2_tween = get_tree().create_tween()
	var start_vfx_tween = get_tree().create_tween()
	center_orb_tween.tween_property(center_orb, "modulate:a", 0, 0.5)
	orbs_tween.tween_property(orbs, "modulate:a", 0, 0.5)
	orbs_2_tween.tween_property(orbs_2, "modulate:a", 0, 0.5)
	start_vfx_tween.tween_property(start_vfx, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	queue_free()
