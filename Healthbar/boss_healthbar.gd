extends TextureProgressBar


@onready var health_timer: Timer = $HealthTimer
@onready var health_damage_bar: TextureProgressBar = $HealthDamageBar
@onready var healthbar: TextureProgressBar = $Healthbar

@onready var health_percent: Label = $HealthPercent

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(healthbar.max_value, new_health)
	healthbar.value = health
	#print(int((new_health / max_value) * 100))
	health_percent.text = "%.1f%%" % ((health / healthbar.max_value) * 100)
	#str(int((new_health / max_value) * 100)) + "%"
	
	#if health <= 0:
		#queue_free()
		
	if health < prev_health:
		health_timer.start()
	else:
		health_damage_bar.value = health

func init_health(_health):
	health = _health
	healthbar.max_value = health
	healthbar.value = health
	health_damage_bar.max_value = health
	health_damage_bar.value = health

func _on_health_timer_timeout() -> void:
	health_damage_bar.value = health
