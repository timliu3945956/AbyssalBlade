extends Control
@onready var label: Label = $MarginContainer/Panel/Label

signal slot_deleted(slot_index: int)
var save_file_selected: int = -1:
	set = set_slot
# Called when the node enters the scene tree for the first time.
func set_slot(slot:int) -> void:
	save_file_selected = slot
	label.text = "Delete save slot %d" % (slot+1)


func _on_yes_button_pressed() -> void:
	if !Global.slot_exists(save_file_selected):
		self.visible = !self.visible
		print("check for save file no exist")
		return
	print("check for save file no exist")
	Global.delete_data(save_file_selected)
	emit_signal("slot_deleted", save_file_selected)
	self.visible = !self.visible


func _on_no_button_pressed() -> void:
	self.visible = !self.visible
