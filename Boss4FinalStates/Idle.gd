extends State

var can_transition: bool = false

func enter():
	super.enter()
	await get_tree().create_timer(6).timeout
	move_boss_to_center()
	animation_player.play("walk")
	await animation_player.animation_finished
	
	can_transition = true
	
func move_boss_to_center():
	owner.dash_audio.play()
	var move_boss = get_tree().create_tween()
	move_boss.tween_property(owner, "position", owner.center_of_screen, 0.3333)
	
func transition():
	if can_transition:
		can_transition = false
		GlobalCount.timer_active = true
		GlobalCount.can_pause = false
		GlobalCount.can_charge = true
		owner.player.charge_icon.value = 0
		#var boss_music = preload("res://audio/music/boss 2 music (loop-ready).wav")
		#AudioPlayer.play_music(owner.boss_music.stream, -40)
		get_parent().change_state("UltimateDenial") #UltimateDenial
