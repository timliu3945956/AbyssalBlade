extends CanvasLayer
var input_enabled := false
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _input(event):
	if !input_enabled:
		return
		
	if event is InputEventMouseButton and event.pressed and input_enabled or event.is_action_pressed("ui_select") and input_enabled:
		input_enabled = false
		TransitionScreen.transition_dead()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")


func _on_video_stream_player_finished() -> void:
	input_enabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 1.0)
