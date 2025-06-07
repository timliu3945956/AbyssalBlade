extends Node

var tween: Tween

func hit_stop_short():
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1
	
func hit_stop_boss_death():
	Engine.time_scale = 0.01
	
	await get_tree().create_timer(0.2, false, false, true).timeout
	
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	#tween.set_ignore_time_scale(true)
	tween.tween_property(Engine, "time_scale", 1.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) #_OUT
	await tween.finished

func hit_stop_boss_death_final():
	Engine.time_scale = 0.01
	
	await get_tree().create_timer(3, false, false, true).timeout
	
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	#tween.set_ignore_time_scale(true)
	tween.tween_property(Engine, "time_scale", 1.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) #_OUT
	await tween.finished
