extends ProgressBar


@onready var health_timer: Timer = $HealthTimer
@onready var health_damage_bar: ProgressBar = $HealthDamageBar

@onready var mana_timer: Timer = $ManaTimer
@onready var mana_damage_bar: ProgressBar = $ManaDamageBar

@onready var health_percent: Label = $HealthPercent

var health = 0 : set = _set_health
var mana = 0 : set = _set_mana

var mana_tween: Tween = null

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	#print(int((new_health / max_value) * 100))
	health_percent.text = "%.1f%%" % ((health / max_value) * 100)
	#str(int((new_health / max_value) * 100)) + "%"
	
	#if health <= 0:
		#queue_free()
		
	if health < prev_health:
		health_timer.start()
	else:
		health_damage_bar.value = health
		
func _set_mana(new_mana):
	var prev_mana = mana
	mana = max(min_value, new_mana)
	if mana > prev_mana:
		mana_damage_bar.value = mana
		mana_timer.start()
	elif mana < prev_mana:
		mana_timer.stop()
		value = mana
		mana_damage_bar.value = mana

func init_health(_health):
	health = _health
	max_value = health
	value = health
	health_damage_bar.max_value = health
	health_damage_bar.value = health
	
func init_mana(_mana):
	mana = _mana
	self.min_value = 0
	self.max_value = 20
	self.value = mana
	mana_damage_bar.min_value = 0
	mana_damage_bar.max_value = max_value
	mana_damage_bar.value = mana
	

func _on_health_timer_timeout() -> void:
	health_damage_bar.value = health

func _on_mana_timer_timeout() -> void:
	if mana_tween:
		mana_tween.kill()
	mana_tween = get_tree().create_tween()
	mana_tween.tween_property(self, "value", mana_damage_bar.value, 0.1).set_trans(Tween.TRANS_LINEAR)
