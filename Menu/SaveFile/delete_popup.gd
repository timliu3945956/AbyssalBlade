extends Control
@onready var label: Label = $MarginContainer/Panel/Label
@onready var yes_button: Button = $MarginContainer/Panel/VBoxContainer/YesButton
@onready var no_button: Button = $MarginContainer/Panel/VBoxContainer/NoButton

@onready var click = preload("res://audio/sfx/Menu/click.mp3")

signal slot_deleted(slot_index: int)
var save_file_selected: int = -1:
	set = set_slot
	
func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
# Called when the node enters the scene tree for the first time.
func set_slot(slot:int) -> void:
	save_file_selected = slot
	label.text = "Delete save slot %d" % (slot+1)

func _on_visibility_changed() -> void:
	if visible and InputManager.activeInputSource == InputManager.InputSource.CONTROLLER:
		call_deferred("grab_default")
		
func grab_default() -> void:
	yes_button.grab_focus()
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and self.visible:
		_on_no_button_pressed()
		accept_event()

func _on_yes_button_pressed() -> void:
	AudioPlayer.play_FX(click, 10)
	if !Global.slot_exists(save_file_selected):
		self.visible = !self.visible
		return
	print("check for save file no exist")
	Global.delete_data(save_file_selected)
	emit_signal("slot_deleted", save_file_selected)
	self.visible = !self.visible


func _on_no_button_pressed() -> void:
	AudioPlayer.play_FX(click, 10)
	self.visible = !self.visible
