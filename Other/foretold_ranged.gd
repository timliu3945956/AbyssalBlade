extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D3

@onready var circle_lightning: AnimatedSprite2D = $vfx/CircleLightning
@onready var lightning_1: AnimatedSprite2D = $vfx/Marker2D/Lightning4
@onready var lightning_2: AnimatedSprite2D = $vfx/Marker2D2/Lightning4
@onready var lightning_3: AnimatedSprite2D = $vfx/Marker2D3/Lightning4
@onready var lightning_4: AnimatedSprite2D = $vfx/Marker2D4/Lightning4
@onready var lightning_5: AnimatedSprite2D = $vfx/Marker2D5/Lightning4
@onready var lightning_6: AnimatedSprite2D = $vfx/Marker2D6/Lightning4
@onready var lightning_ember_1: AnimatedSprite2D = $vfx/EmberMarker1/LightningEmber2
@onready var lightning_ember_2: AnimatedSprite2D = $vfx/EmberMarker2/LightningEmber2
@onready var lightning_ember_3: AnimatedSprite2D = $vfx/EmberMarker3/LightningEmber2
@onready var lightning_ember_4: AnimatedSprite2D = $vfx/EmberMarker4/LightningEmber2
@onready var lightning_ember_5: AnimatedSprite2D = $vfx/EmberMarker5/LightningEmber2
@onready var lightning_ember_6: AnimatedSprite2D = $vfx/EmberMarker6/LightningEmber2


func _ready():
	animation_player.play("foretold_telegraph")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "foretold_telegraph":
		animation_player.play("attack_anim")
		circle_lightning.play("default")
		lightning_1.play("default")
		lightning_2.play("default")
		lightning_3.play("default")
		lightning_4.play("default")
		lightning_5.play("default")
		lightning_6.play("default")
		lightning_ember_1.play("default")
		lightning_ember_2.play("default")
		lightning_ember_3.play("default")
		lightning_ember_4.play("default")
		lightning_ember_5.play("default")
		lightning_ember_6.play("default")
	
		collision.disabled = false
		await get_tree().create_timer(0.0833).timeout
		collision.disabled = true

#func _on_circle_lightning_animation_finished() -> void:
	


func _on_foretold_audio_2_finished() -> void:
	queue_free()
