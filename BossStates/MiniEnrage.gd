extends State
@onready var shout_mini_enrage: AnimatedSprite2D = $"../../ShoutMiniEnrage"

var can_transition: bool = false

func enter():
	super.enter()
	owner.velocity = Vector2.ZERO
	animation_player.play("mini_enrage")
	await TimeWait.wait_sec(0.5833)#await get_tree().create_timer(0.5833).timeout
	owner.enrage_background.play("background_change")
	
	owner.enrage_fire.emitting = true
	owner.enrage_fire.visible = true
	
	#modify collision shape of slash here or in animationplayer
	await owner.enrage_background.animation_finished
	animation_player.play("idle_right")
	await TimeWait.wait_sec(2)#await get_tree().create_timer(2).timeout #originally 1 second
	can_transition = true
	
func transition():
	if can_transition:
		can_transition = false
		owner.timeline += 1
		get_parent().change_state("Transition")
