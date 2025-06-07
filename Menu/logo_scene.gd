extends CenterContainer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var end_music: AudioStreamPlayer2D = $EndMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music(end_music.stream, -15)
	animation_player.play("fade_in")
	await animation_player.animation_finished
	await get_tree().create_timer(2).timeout
	animation_player.play("fade_out")
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	TransitionScreen.transition_main_menu()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Menu/credits-scene/credits.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
