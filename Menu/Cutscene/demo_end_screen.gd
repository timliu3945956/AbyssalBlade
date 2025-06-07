extends CanvasLayer
var input_enabled := true

# Called when the node enters the scene tree for the first time.
func _input(event):
	if !input_enabled:
		return
		
	if event is InputEventMouseButton and event.pressed:
		input_enabled = false
		TransitionScreen.transition_dead()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")
