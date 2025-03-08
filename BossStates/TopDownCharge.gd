extends State

@onready var spawn_shadow_audio: AudioStreamPlayer2D = $"../../SpawnShadowAudio"


var can_transition: bool = false

func enter() -> void:
	super.enter()
	owner.velocity = Vector2.ZERO
	owner.choose_top_down = randi_range(1, 2)
	animation_player.play("mini_enrage")
	await get_tree().create_timer(0.40).timeout
	match owner.choose_top_down:
		1:
			owner.smoke_top_1.play("smoke")
			owner.smoke_top_2.play("smoke")
			owner.boss_room_animation.play("top_charge")
			spawn_shadow_audio.play()
		2:
			owner.smoke_bottom_1.play("smoke")
			owner.smoke_bottom_2.play("smoke")
			owner.boss_room_animation.play("bottom_charge")
			spawn_shadow_audio.play()
	#owner.boss_room_animation.play("top_charge")
	await animation_player.animation_finished
	can_transition = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
		
