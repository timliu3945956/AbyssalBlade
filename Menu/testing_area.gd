extends Panel

signal left_click_permitted
signal right_click_permitted

var is_mouse_in_panel = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_mouse_in_panel:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					emit_signal("left_click_permitted")
				MOUSE_BUTTON_RIGHT:
					emit_signal("right_click_permitted")

func _on_mouse_entered() -> void:
	GlobalCount.is_mouse_in_panel = true
	

func _on_mouse_exited() -> void:
	GlobalCount.is_mouse_in_panel = false
	
