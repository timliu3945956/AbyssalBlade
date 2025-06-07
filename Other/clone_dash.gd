extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dash: AudioStreamPlayer2D = $dash

func _ready():
	animation_player.play("dash_out")
	dash.play()
	await get_tree().create_timer(24.3333).timeout
	animation_player.play("dash_in")
	dash.play()
	await animation_player.animation_finished
	queue_free()
