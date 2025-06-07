extends CanvasLayer

signal on_transition_finished

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
#func _input(event):
	#if is_transitioning:
		#event.consume()
		
#func _unhandled_input(event):
	#if is_transitioning:
		#accept_event()

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		#is_transitioning = true
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_black_dead":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
		is_transitioning = false
	elif anim_name == "fade_to_black_main_menu":
		on_transition_finished.emit()
		animation_player.play("fade_to_main_menu")
	elif anim_name == "fade_to_main_menu":
		color_rect.visible = false
		is_transitioning = false
	elif anim_name == "fade_to_black_cutscene":
		await get_tree().create_timer(2).timeout
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
func transition_dead():
	#if is_transitioning:
		#return
	#is_transitioning = true
	color_rect.visible = true
	animation_player.play("fade_to_black_dead")
	AudioPlayer.fade_out_music(2.5)
	
func transition_cutscene():
	color_rect.visible = true
	animation_player.play("fade_to_black_cutscene")
	
func transition_end_game():
	color_rect.visible = true
	animation_player.play("fade_to_black_end")
	
func transition_main_menu():
	color_rect.visible = true
	animation_player.play("fade_to_black_main_menu")
