extends Node2D

@onready var interact_collision: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var click_vfx = preload("res://audio/sfx/Menu/click.mp3")
@onready var player = get_parent().find_child("Player")
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var music_page = preload("res://Menu/MusicSelect.tscn")

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	interact_collision.disabled = true
	AudioPlayer.play_FX(click_vfx, 10)
	GlobalCount.paused = true
	music_page_add()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "change_songs":
		animation_player.play("play_song")

func music_page_add():
	var music_UI = music_page.instantiate()
	music_UI.player = player
	music_UI.interact_collision = interact_collision
	music_UI.anim_player = animation_player
	get_parent().add_child(music_UI)
