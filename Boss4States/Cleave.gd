extends State
@onready var beam_audio: AudioStreamPlayer2D = $"../../BeamAudio"

var can_transition: bool = false
var red_sword_tween: Tween


func enter():
	super.enter()
	owner.direction = Vector2.ZERO
	
	owner.attack_meter_animation.play("bait_cleave")
	tether_vfx()
	await owner.attack_meter_animation.animation_finished
	tether_stop()
	owner.spawn_cleave()
	await get_tree().create_timer(3).timeout
	
	owner.cleave_count += 1
	can_transition = true
	
func tether_vfx():
	owner.tether_vfx_spawn()
	owner.vfx_timer.start()
	owner.spawn_tether()
	player.tether_vfx_spawn()
	player.vfx_timer.start()

func tether_stop():
	owner.vfx_timer.stop()
	player.vfx_timer.stop()
	
func transition():
	if can_transition:
		can_transition = false
		match owner.cleave_count:
			1:
				get_parent().change_state("GoldCloneSpawn")
			2:
				get_parent().change_state("Oblivion")
			3:
				get_parent().change_state("GoldCloneSpawn")
			4:
				get_parent().change_state("Oblivion")
			5:
				get_parent().change_state("Oblivion")
		
