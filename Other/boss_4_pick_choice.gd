extends Control

@onready var take_blade_label: Sprite2D = $MarginContainer/HBoxContainer/TakeButton/TakeBladeLabel
@onready var destroy_blade_label: Sprite2D = $MarginContainer/HBoxContainer/DestroyButton/DestroyBladeLabel
@onready var cutscene_player: AnimationPlayer = $"../../CutscenePlayer"
@onready var back_audio: AudioStreamPlayer2D = $BackAudio
@onready var take_button: Button = $MarginContainer/HBoxContainer/TakeButton
@onready var destroy_button: Button = $MarginContainer/HBoxContainer/DestroyButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	take_button.focus_entered.connect(_on_take_button_mouse_entered)
	take_button.focus_exited.connect(_on_take_button_mouse_exited)
	destroy_button.focus_entered.connect(_on_destroy_button_mouse_entered)
	destroy_button.focus_exited.connect(_on_destroy_button_mouse_exited)
	
	take_button.focus_neighbor_right = destroy_button.get_path()
	destroy_button.focus_neighbor_left = take_button.get_path()
	
	get_viewport().gui_release_focus()

func _unhandled_input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() != null:
		return
		
	if event.is_action_pressed("ui_left"):
		take_button.grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		destroy_button.grab_focus()
		get_viewport().set_input_as_handled()

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
