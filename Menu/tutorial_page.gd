extends Control

@onready var _labels := {
	"Movement"      : $"CanvasLayer/DescriptionContainer/MarginContainer/MovementText",
	"Aiming"        : $"CanvasLayer/DescriptionContainer/MarginContainer/AimingText",
	"Hurtbox"       : $"CanvasLayer/DescriptionContainer/MarginContainer/HurtboxText",
	"Death"         : $"CanvasLayer/DescriptionContainer/MarginContainer/DeathText",
	"AbyssalGauge"  : $"CanvasLayer/DescriptionContainer/MarginContainer/AbyssalGaugeText",
	"Slash"         : $"CanvasLayer/DescriptionContainer/MarginContainer/SlashText",
	"Cleave"        : $"CanvasLayer/DescriptionContainer/MarginContainer/CleaveText",
	"Dash"          : $"CanvasLayer/DescriptionContainer/MarginContainer/DashText",
	"Charge"        : $"CanvasLayer/DescriptionContainer/MarginContainer/ChargeText",
	"Surge"         : $"CanvasLayer/DescriptionContainer/MarginContainer/SurgeText",
	"SurgeSlash"    : $"CanvasLayer/DescriptionContainer/MarginContainer/SurgeSlashText",
}

@onready var _buttons := $"CanvasLayer/PanelContainer/ButtonContainer/VBoxContainer".get_children()
@onready var click_vfx = preload("res://audio/sfx/Menu/click.mp3")

var player: CharacterBody2D
var interact_collision: CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for label in _labels.values():
		label.visible = false
		
	for button in _buttons:
		var key := button.name.replace("Button", "")
		button.pressed.connect(_on_button_pressed.bind(key))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		interact_collision.disabled = false
		AudioPlayer.play_FX(click_vfx, 0)
		GlobalCount.paused = false
		accept_event()
		queue_free()

func _on_button_pressed(key: String) -> void:
	AudioPlayer.play_FX(click_vfx, 0)
	for k in _labels:
		_labels[k].visible = (k == key)

func _on_back_pressed() -> void:
	interact_collision.disabled = false
	AudioPlayer.play_FX(click_vfx, 0)
	GlobalCount.paused = false
	queue_free()
