extends Node2D

@onready var chargeup_energy_1: AnimatedSprite2D = $ChargeupEnergy1
@onready var chargeup_energy_2: AnimatedSprite2D = $ChargeupEnergy2
@onready var impact_shock_1: AnimatedSprite2D = $ImpactShock1
@onready var impact_shock_2: AnimatedSprite2D = $ImpactShock2
@onready var split_audio: AudioStreamPlayer2D = $SplitAudio


func _ready():
	
	impact_shock_1.position = Vector2(-250, 0)
	impact_shock_2.position = Vector2(250, 0)
	chargeup_energy_1.position = Vector2(-250, 0)
	chargeup_energy_2.position = Vector2(250, 0)
	impact_shock_1.play("default")
	impact_shock_2.play("default")
	split_audio.play()
	chargeup_energy_1.visible = true
	chargeup_energy_2.visible = true
	chargeup_energy_1.play("default")
	chargeup_energy_2.play("default")
	var ball_tween_1 = get_tree().create_tween()
	ball_tween_1.tween_property(chargeup_energy_1, "position", Vector2(0, 0), 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var ball_tween_2 = get_tree().create_tween()
	ball_tween_2.tween_property(chargeup_energy_2, "position", Vector2(0, 0), 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(2).timeout
	chargeup_energy_1.visible = false
	chargeup_energy_2.visible = false
	impact_shock_1.rotation = randf() * 360
	impact_shock_2.rotation = randf() * 360
	impact_shock_1.position = Vector2(0, 0)
	impact_shock_2.position = Vector2(0, 0)
	split_audio.play()
	impact_shock_1.play("default")
	impact_shock_2.play("default")
	await impact_shock_1.animation_finished
	queue_free()
	

func _on_chargeup_energy_1_animation_looped() -> void:
	chargeup_energy_1.rotation = randf() * 360

func _on_chargeup_energy_2_animation_looped() -> void:
	chargeup_energy_2.rotation = randf() * 360
