extends State

var GoldOrb = preload("res://Other/DevourGold.tscn")
var RedOrb = preload("res://Other/DevourRed.tscn")

var can_transition: bool = false
var boss_room_center = Vector2.ZERO
var red_sword_tween: Tween

func enter():
	super.enter()
	animation_player.play("idle")
	owner.attack_meter_animation.play("engulfing_curse")
	red_sword_tween = get_tree().create_tween()
	red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.3)
	await owner.attack_meter_animation.animation_finished
	animation_player.play("inbuement")
	#if player.oppressive_color == "white":
	owner.sword_animation_player.play("spawn_red")
	await owner.sword_animation_player.animation_finished
		#owner.camera_shake()
	owner.black_fire_spawn.play("default")
	owner.black_fire_spawn_2.play("default")
	owner.white_fire_spawn.play("default")
	owner.white_fire_spawn_2.play("default")
	owner.red_swords.modulate.a = 0
		
		#owner.sword_animation_player.play("spawn_black")
		#await owner.sword_animation_player.animation_finished
	owner.sword_animation_player.play("swords_idle")
	owner.dual_color_swords.modulate.a = 1
		#owner.black_swords.modulate.a = 1
	#else:
		#owner.sword_animation_player.play("spawn_red")
		#await owner.sword_animation_player.animation_finished
		##owner.camera_shake()
		#owner.white_fire_spawn.play("default")
		#owner.white_fire_spawn_2.play("default")
		#owner.red_swords.modulate.a = 0
		#owner.sword_animation_player.play("spawn_white")
		#await owner.sword_animation_player.animation_finished
		#owner.sword_animation_player.play("swords_idle")
		#owner.white_swords.modulate.a = 1
		
		#var red_sword_tween = get_tree().create_tween()
		#var swords_tween = get_tree().create_tween()
		#red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
		#swords_tween.tween_property(owner.white_swords, "modulate:a", 1, 0.5)
	await TimeWait.wait_sec(1)#await get_tree().create_timer(1).timeout
	can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("BarrageOpposite")
