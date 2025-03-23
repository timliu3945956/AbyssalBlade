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
		#red_sword_tween = get_tree().create_tween()
		#red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.5)
	else:
		owner.attack_meter_animation.play("looming_desolation")
	await get_tree().create_timer(3.5).timeout
	
	
	await owner.attack_meter_animation.animation_finished
	owner.crown_appear_vfx.play_backwards("default")
	if owner.looming_count != 2:
		if player.oppressive_color == "white":
			var red_crown_tween = get_tree().create_tween()
			red_crown_tween.tween_property(owner.red_crown, "modulate:a", 0, 0.5)
			var red_crown_expand_tween = get_tree().create_tween()
			red_crown_expand_tween.tween_property(owner.red_crown_expand, "modulate:a", 0, 0.5)
			var crown_tween = get_tree().create_tween()
			crown_tween.tween_property(owner.white_crown, "modulate:a", 1, 0.5)
			var white_crown_expand_tween = get_tree().create_tween()
			white_crown_expand_tween.tween_property(owner.white_crown_expand, "modulate:a", 1, 0.5)
			owner.crown_color = "white"
		else:
			var red_crown_tween = get_tree().create_tween()
			red_crown_tween.tween_property(owner.red_crown, "modulate:a", 0, 0.5)
			var red_crown_expand_tween = get_tree().create_tween()
			red_crown_expand_tween.tween_property(owner.red_crown_expand, "modulate:a", 0, 0.5)
			var crown_tween = get_tree().create_tween()
			crown_tween.tween_property(owner.black_crown, "modulate:a", 1, 0.5)
			var black_crown_expand_tween = get_tree().create_tween()
			black_crown_expand_tween.tween_property(owner.black_crown_expand, "modulate:a", 1, 0.5)
			
			owner.crown_color = "black"
	else: #red crown
		var crown_tween = get_tree().create_tween()
		crown_tween.tween_property(owner.red_crown, "modulate:a", 1, 0.5)
		var red_crown_expand_tween = get_tree().create_tween()
		red_crown_expand_tween.tween_property(owner.red_crown_expand, "modulate:a", 1, 0.5)
		
		#red_sword_tween = get_tree().create_tween()
		#red_sword_tween.tween_property(owner.red_swords, "modulate:a", 1, 0.5)
		owner.crown_color = "red"
	await get_tree().create_timer(0.5).timeout
	owner.looming_count += 1
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
	
