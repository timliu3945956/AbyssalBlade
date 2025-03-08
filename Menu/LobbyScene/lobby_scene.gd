extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalCount.can_pause = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#func _on_area_2d_body_entered(_body: Node2D) -> void:
	#GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	#LoadManager.load_scene("res://Menu/StageSelect/stage_select.tscn")
