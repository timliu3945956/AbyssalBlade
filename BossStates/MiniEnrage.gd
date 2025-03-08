extends State
@onready var shout_mini_enrage: AnimatedSprite2D = $"../../ShoutMiniEnrage"

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	#await get_tree().create_timer(1).timeout
	animation_player.play("mini_enrage")
	#await get_tree().create_timer(0.5).timeout
	#shout_mini_enrage.play("shout")
	await get_tree().create_timer(0.5833).timeout
	owner.enrage_background.play("background_change")
	
	owner.enrage_fire.emitting = true
	owner.enrage_fire.visible = true
	
	#modify collision shape of slash here or in animationplayer
	await owner.enrage_background.animation_finished
	animation_player.play("idle_right")
	await get_tree().create_timer(2).timeout #originally 1 second
	#await animation_player.animation_finished
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
