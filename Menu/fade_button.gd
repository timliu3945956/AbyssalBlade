extends Button

@onready var background1: Node2D = $"../../../../Background1/Node2D"
@onready var background2: Node2D = $"../../../../Background2/Node2D"
@onready var background3: Node2D = $"../../../../Background3/Node2D"
@onready var description_1: Label = $"../../../../DescriptionContainer/Description1"
@onready var description_2: Label = $"../../../../DescriptionContainer/Description2"
@onready var description_3: Label = $"../../../../DescriptionContainer/Description3"


var fade_tween : Tween
var focused: bool = false
var background_tween1: Tween
var background_tween2: Tween
var background_tween3: Tween
var description_tween1: Tween
var description_tween2: Tween
var description_tween3: Tween


func _ready():
	modulate = Color(1, 1, 1, 0.5)
	
func _input(event):
	if !InputCheck.is_mouse:
		if !focused:
			grab_focus()
			focused = true
	else:
		if focused:
			release_focus()
			focused = false
	#if event is InputEventJoypadButton or (event is InputEventJoypadMotion):
		#if !focused:
			#focused = true
			#grab_focus()
	#else:
		#focused = false
		#release_focus()

#func _on_mouse_entered() -> void:
	#fade_tween = create_tween()
	#fade_tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	#if background1.modulate.a == 0:
		#background_tween1 = create_tween()
		#background_tween1.tween_property(background1, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	#if background2.modulate.a == 1:
		#background_tween2 = create_tween()
		#background_tween2.tween_property(background2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	#if background3.modulate.a == 1:
		#background_tween3 = create_tween()
		#background_tween3.tween_property(background2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		#
	#if description_1.modulate.a == 0:
		#description_tween1 = create_tween()
		#description_tween1.tween_property(description_1, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	#if description_2.modulate.a == 1:
		#description_tween2 = create_tween()
		#description_tween2.tween_property(description_2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	#if description_3.modulate.a == 1:
		#description_tween3 = create_tween()
		#description_tween3.tween_property(description_3, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		#
#
#func _on_mouse_exited() -> void:
	#fade_tween = create_tween()
	#fade_tween.tween_property(self, "modulate:a", 0.5, 0.5).set_trans(Tween.TRANS_LINEAR)
#
#func _on_focus_entered() -> void:
	#fade_tween = create_tween()
	#fade_tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
#
#func _on_focus_exited() -> void:
	#fade_tween = create_tween()
	#fade_tween.tween_property(self, "modulate:a", 0.5, 0.5).set_trans(Tween.TRANS_LINEAR)


func _on_pressed() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	if background1.modulate.a == 0:
		background_tween1 = create_tween()
		background_tween1.tween_property(background1, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if background2.modulate.a == 1:
		background_tween2 = create_tween()
		background_tween2.tween_property(background2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if background3.modulate.a == 1:
		background_tween3 = create_tween()
		background_tween3.tween_property(background3, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
		
	if description_1.modulate.a == 0:
		description_tween1 = create_tween()
		description_tween1.tween_property(description_1, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if description_2.modulate.a == 1:
		description_tween2 = create_tween()
		description_tween2.tween_property(description_2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	if description_3.modulate.a == 1:
		description_tween3 = create_tween()
		description_tween3.tween_property(description_3, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	
