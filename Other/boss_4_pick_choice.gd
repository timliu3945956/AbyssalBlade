extends Control

@onready var take_blade_label: Sprite2D = $MarginContainer/HBoxContainer/TakeButton/TakeBladeLabel
@onready var destroy_blade_label: Sprite2D = $MarginContainer/HBoxContainer/DestroyButton/DestroyBladeLabel
@onready var cutscene_player: AnimationPlayer = $"../../CutscenePlayer"
@onready var back_audio: AudioStreamPlayer2D = $BackAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_take_button_pressed() -> void:
	back_audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(take_blade_label, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(take_blade_label, "scale", Vector2(0.35, 0.35), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	self.visible = false
	take_blade_label.visible = false
	cutscene_player.play("cutscene_take_blade")
	await cutscene_player.animation_finished
	var achievement_bad_ending = Steam.getAchievement("BadEnding")
	if achievement_bad_ending.ret && !achievement_bad_ending.achieved:
		Steam.setAchievement("BadEnding")
		Steam.storeStats()
	

func _on_destroy_button_pressed() -> void:
	back_audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(destroy_blade_label, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(destroy_blade_label, "scale", Vector2(0.35, 0.35), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	self.visible = false
	destroy_blade_label.visible = false
	cutscene_player.play("cutscene_destroy_blade")

func _on_take_button_mouse_entered() -> void:
	take_blade_label.self_modulate = Color(0, 0, 0)

func _on_take_button_mouse_exited() -> void:
	take_blade_label.self_modulate = Color(1, 1, 1)

func _on_destroy_button_mouse_entered() -> void:
	destroy_blade_label.modulate = Color(0, 0, 0)

func _on_destroy_button_mouse_exited() -> void:
	destroy_blade_label.modulate = Color(1, 1, 1)
