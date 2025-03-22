extends State

var GoldOrb = preload("res://Other/DevourGold.tscn")
var RedOrb = preload("res://Other/DevourRed.tscn")

var can_transition: bool = false
var boss_room_center = Vector2.ZERO

func enter():
	super.enter()
	animation_player.play("idle")
	owner.attack_meter_animation.play("engulfing_curse")
	await owner.attack_meter_animation.animation_finished
	if player.oppressive_color == "white":
		var red_sword_tween = get_tree().create_tween()
		var swords_tween = get_tree().create_tween()
		red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
		swords_tween.tween_property(owner.black_swords, "modulate:a", 1, 0.5)
	else:
		var red_sword_tween = get_tree().create_tween()
		var swords_tween = get_tree().create_tween()
		red_sword_tween.tween_property(owner.red_swords, "modulate:a", 0, 0.5)
		swords_tween.tween_property(owner.white_swords, "modulate:a", 1, 0.5)
	await get_tree().create_timer(0.5).timeout
	can_transition = true

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("BarrageOpposite")
