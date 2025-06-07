extends Node

var slow_motion_active: bool = false

var normal_time_scale: float = 1.0
var slow_time_scale: float = 0.2

var tween: Tween

func enter_slowmo_animation():
	#if tween and tween.is_running():
		#tween.kill()
	#tween = get_tree().create_tween()
	#tween.tween_property(Engine, "time_scale", slow_time_scale, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#await tween.finished
	start_slowmo()

func exit_slowmo_animation():
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", normal_time_scale, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) #_OUT
	await tween.finished
	end_slowmo()

func start_slowmo():
	Engine.time_scale = slow_time_scale
	
func end_slowmo():
	Engine.time_scale = normal_time_scale

func request_slowmo_change():
	if !slow_motion_active:
		enter_slowmo_animation()
	else:
		exit_slowmo_animation()
	slow_motion_active = !slow_motion_active
