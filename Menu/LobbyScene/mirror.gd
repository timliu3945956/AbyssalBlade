extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	GlobalCount.previous_scene_path = get_tree().current_scene.get_scene_file_path()
	LoadManager.load_scene("res://Menu/StageSelect/stage_select.tscn")
	
