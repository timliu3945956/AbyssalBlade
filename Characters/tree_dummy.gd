extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $FlashTimer

@onready var hit_particles: CPUParticles2D = $HitParticles

@onready var player = get_parent().find_child("Player")

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
	#print(area.name)
	#flash()
	#hit_particles.rotation = position.angle_to_point(player.position) + PI
	#hit_particles.emitting = true
	#
	#if player.swing.playing:
		#player.swing.stop()
	#if player.transformed:
		#player.heavy_hit.play()
	#else:
		#player.hit.play()
	#
	#if player.mana < 10:
		#player.mana += 1
		#if player.mana >= 10:
			#player.surge_ready.play()
			#player.mana_bar_fire.process_material.color.a = 1.0
			#player.mana_bar_fire.emitting = true
			
	if area.name == "HitBox":
		flash()
		hit_particles.rotation = position.angle_to_point(player.position) + PI
		hit_particles.emitting = true
		
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
			player.abyssal_surge_hit.play()
		else:
			player.hit.play()
		
		if player.mana < 20:
			player.mana += 1
			if player.mana >= 20:
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
	elif area.name == "HeavyHitBox":
		flash()
		hit_particles.rotation = position.angle_to_point(player.position) + PI
		hit_particles.emitting = true
		if player.swing.playing:
			player.swing.stop()
		
		player.heavy_hit.play()
		
		if player.mana < 20:
			player.mana += 4 #4
			if player.mana >= 20:
				player.surge_ready.play()
				
				player.mana_bar_fire.process_material.color.a = 1.0
				player.mana_bar_fire.emitting = true
			
