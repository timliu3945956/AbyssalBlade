extends Node2D

@onready var interact_collision: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var click_vfx = preload("res://audio/sfx/Menu/click.mp3")
@onready var player = get_parent().find_child("Player")
@onready var interaction_area: InteractionArea = $InteractionArea
var guide_page = preload("res://Menu/TutorialPage.tscn")

var dialogue_resource = preload("res://dialogue/npc_dialogue.dialogue")
#var balloon_scene_path = "res://dialogue/npc_balloon.tscn"

var select_dialogue: String = "NPC"

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	interact_collision.disabled = true
	AudioPlayer.play_FX(click_vfx, 0)
	GlobalCount.stage_select_pause = true
	GlobalCount.in_subtree_menu = true
	GlobalCount.paused = true
	player.set_process(false)
	player.canvas_layer.visible = false
	#DialogueManager.show_dialogue_balloon(dialogue_resource, select_dialogue)
	DialogueManager.show_custom_dialogue_balloon("res://dialogue/npc_balloon.tscn", dialogue_resource, select_dialogue)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(0.1).timeout
	player.canvas_layer.visible = true
	player.set_process(true)
	interact_collision.disabled = false
	GlobalCount.paused = false
	GlobalCount.in_subtree_menu = false
	GlobalCount.stage_select_pause = false
	#open_guide()
	
func open_guide():
	var guide = guide_page.instantiate()
	guide.player = player
	guide.interact_collision = interact_collision
	get_parent().add_child(guide)
