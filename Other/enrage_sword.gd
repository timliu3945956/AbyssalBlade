extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_enrage: Sprite2D = $SwordEnrage

func _ready():
	animation_player.play("sword_enrage_appear")
	await animation_player.animation_finished
	#self.position = Vector2(0, 7)
	animation_player.play("sword_grow_particle")
	await animation_player.animation_finished
	

func camera_shake():
	GlobalCount.camera.apply_shake(5.0, 15.0)
	
func camera_shake_2():
	GlobalCount.camera.apply_shake(10.0, 20.0)
	
func camera_shake_3():
	GlobalCount.camera.apply_shake(20.0, 20.0)

func decellerate():
	var tween = get_tree().create_tween()
	tween.tween_property(sword_enrage, "position", sword_enrage.position + Vector2(0, -10), 0.5) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_OUT)

func sword_flash():
	animation_player.play("sword_flash")
