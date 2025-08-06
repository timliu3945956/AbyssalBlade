extends Node

const DAMAGE_TEXT = preload("res://Singleton/DamageText.tscn")

func damage_text(_damage : int, _pos : Vector2) -> void:
	var _t : DamageText = DAMAGE_TEXT.instantiate()
	add_child(_t)
	_t.start(str(_damage), _pos)
	
