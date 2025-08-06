extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer
@onready var player = get_parent().find_child("Player")

var hit_particle = preload("res://Other/hit_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()
	

func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifier", 0)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		EffectManager.damage_text(player.damage_amount, global_position + Vector2(0, -25))
		flash()
		if player.transformed:
			spawn_attack_vfx("surge")
		else:
			spawn_attack_vfx("normal")
		player.attack_count += 1
		if player.dash_gauge >= 3 and not player.transformed:
			player.attack_count = 0
		if player.attack_count >= 3 and not player.transformed:
			player.dash_gauge += 1
			player.count_dash_gauge()
			player.attack_count = 0
		
		if player.swing.playing:
			player.swing.stop()
		if player.transformed:
			player.play_with_random_pitch(player.abyssal_surge_hit, 0.9, 1.15)
			#player.abyssal_surge_hit.play()
		else:
			player.play_with_random_pitch(player.hit, 0.9, 1.15)
			#player.hit.play()
		
		if player.mana < 100:
			player.mana += 3
			if player.mana >= 100:
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
	elif area.name == "HeavyHitBox":
		EffectManager.damage_text(player.damage_amount * 8, global_position + Vector2(0, -25))
		flash()
		if player.swing.playing:
			player.swing.stop()
		
		spawn_attack_vfx("heavy")
		player.play_with_random_pitch(player.heavy_hit, 0.9, 1.15)
		#player.heavy_hit.play()
		
		if player.mana < 100:
			player.mana += 20 #4
			if player.mana >= 100:
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
				
func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)
			
