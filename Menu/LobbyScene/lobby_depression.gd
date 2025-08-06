extends Node2D

@onready var interact_collision: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var click_vfx = preload("res://audio/sfx/Menu/click.mp3")
@onready var player = get_parent().find_child("Player")
@onready var interaction_area: InteractionArea = $InteractionArea

var dialogue_resource = preload("res://dialogue/npc_dialogue.dialogue")
var select_dialogue: String = "DEPRESSION"

func _ready() -> void:
	interact_collision.disabled = Global.player_data_slots[Global.current_slot_index].first_play_4
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	interact_collision.disabled = true
	AudioPlayer.play_FX(click_vfx, 10)
	GlobalCount.stage_select_pause = true
	GlobalCount.in_subtree_menu = true
	GlobalCount.paused = true
	player.set_process(false)
	player.canvas_layer.visible = false
	DialogueManager.show_custom_dialogue_balloon("res://dialogue/npc_balloon.tscn", dialogue_resource, select_dialogue)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(0.1).timeout
	player.canvas_layer.visible = true
	player.set_process(true)
	interact_collision.disabled = false
	GlobalCount.paused = false
	GlobalCount.stage_select_pause = false
	GlobalCount.in_subtree_menu = false
	
