extends State

var GoldOrb = preload("res://Other/DevourGold.tscn")
var RedOrb = preload("res://Other/DevourRed.tscn")

var can_transition: bool = false
var boss_room_center = Vector2.ZERO
var red_sword_tween: Tween
func enter():
	super.enter()
	animation_player.play("idle")
	if owner.looming_count != 2:
		owner.attack_meter_animation.play("looming_havoc")
	else:
		owner.attack_meter_animation.play("looming_desolation")
	await owner.attack_meter_animation.animation_finished
	owner.crown_appear_vfx.play_backwards("default")
	await get_tree().create_timer(0.4).timeout
	#owner.camera_shake()
	if owner.looming_count != 2:
		if player.oppressive_color == "white":
			owner.red_crown.modulate.a = 0
			owner.red_crown_expand.modulate.a = 0
			owner.white_crown.modulate.a = 1
			owner.white_crown_expand.modulate.a = 1
			owner.crown_color = "white"
			owner.crown_aura_white.modulate.a = 1
			owner.crown_aura_white.play("default")
		else:
			owner.red_crown.modulate.a = 0
			owner.red_crown_expand.modulate.a = 0
			owner.black_crown.modulate.a = 1
			owner.black_crown_expand.modulate.a = 1
			owner.crown_color = "black"
			owner.crown_aura_black.modulate.a = 1
			owner.crown_aura_black.play("default")
	else: #red crown
		owner.red_crown.modulate.a = 1
		owner.red_crown_expand.modulate.a = 1
		owner.crown_color = "red"
		owner.crown_aura_red.modulate.a = 1
		owner.crown_aura_red.play("default")
	await get_tree().create_timer(0.5).timeout
	owner.looming_count += 1
	print(owner.crown_color)
	can_transition = true

func transition():
	if can_transition:
		can_transition = false
		if owner.looming_count == 3:
			get_parent().change_state("Enrage")
		else:
			get_parent().change_state("EngulfingCurse")
		#
		#can_transition = true
	
