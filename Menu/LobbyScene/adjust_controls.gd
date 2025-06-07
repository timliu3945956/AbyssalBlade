extends Control
@onready var click = preload("res://audio/sfx/Menu/click.mp3")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var panel: Panel = $CanvasLayer/Panel

var controls_screen = preload("res://Menu/Controls.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.visible = false
	if GlobalCount.first_time_play:
		GlobalCount.paused = true
		GlobalCount.in_subtree_menu = true
		await get_tree().create_timer(7).timeout
		GlobalCount.first_time_play = false
		canvas_layer.visible = true
		AudioPlayer.play_FX(click, 0)
		

func _on_yes_button_pressed() -> void:
	GlobalCount.in_subtree_menu = true
	AudioPlayer.play_FX(click, 0)
	panel.visible = false
	var control_panel = controls_screen.instantiate()
	canvas_layer.add_child(control_panel)
	control_panel.connect("closed", _on_subtree_closed)
	
func _on_subtree_closed() -> void:
	canvas_layer.visible = false
	GlobalCount.paused = false
	GlobalCount.first_time_play = false
	GlobalCount.in_subtree_menu = false


func _on_no_button_pressed() -> void:
	canvas_layer.visible = false
	GlobalCount.paused = false
	GlobalCount.first_time_play = false
	GlobalCount.in_subtree_menu = false
