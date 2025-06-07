extends CanvasLayer

signal on_transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wind_music: AudioStreamPlayer2D = $AudioStreamPlayer2D

var dialogue_resource = preload("res://dialogue/start_game.dialogue")
var select_dialogue: String = "MainMenu"

func _ready() -> void:
	GlobalCount.stage_select_pause = true
	await get_tree().create_timer(2).timeout
	AudioPlayer.play_music(wind_music.stream, -10)
	animation_player.play("fade_in")
	await animation_player.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue_resource, select_dialogue)
	await TransitionScreen.on_transition_finished
	#----------------- FOR DEMO
	#if select_dialogue == "DenialEnd":
		#get_tree().change_scene_to_file("res://Menu/Cutscene/DemoEndScreen.tscn")
	#else:
	GlobalCount.stage_select_pause = false
	get_tree().change_scene_to_file("res://Menu/LobbyScene/lobby_scene.tscn")
	
func play_cutscene():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in_black":
		emit_signal("on_transition_finished")
