extends Node2D

@onready var blade: Sprite2D = $Blade
@onready var gem: Sprite2D = $Gem
@onready var gold_gem: Sprite2D = $Gem/GoldGem

@onready var flash_timer: Timer = $FlashTimer
@onready var player = get_parent().find_child("Player")
@onready var knockback_effect: AnimatedSprite2D = $KnockbackEffect
@onready var knockback_audio: AudioStreamPlayer2D = $KnockbackAudio
@onready var gold_particles_2: GPUParticles2D = $GoldParticles2

var hit_particle = preload("res://Other/hit_particles.tscn")

const GEM_TEXTURES = [
	preload("res://Utilities/menu/save file/gems_1.png"),
	preload("res://Utilities/menu/save file/gems_2.png"),
	preload("res://Utilities/menu/save file/gems_3.png"),
	preload("res://Utilities/menu/save file/gems_4.png"),
	preload("res://Utilities/menu/save file/gems_clear.png"),
]

const GOLD_TEXTURES = [
	preload("res://Utilities/menu/save file/gold_gems_1.png"),
	preload("res://Utilities/menu/save file/gold_gems_2.png"),
	preload("res://Utilities/menu/save file/gold_gems_3.png"),
	preload("res://Utilities/menu/save file/gold_gems_4.png")
]

const BOSS_FLAGS := ["first_play_1", "first_play_2", "first_play_3", "first_play_4", "first_play_6"]

const GOLD_BOSS_FLAGS := [
	"abyss_best_time_boss_1",
	"abyss_best_time_boss_2",
	"abyss_best_time_boss_3",
	"abyss_best_time_boss_4"
]

func _ready():
	if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5 > 0.0:
		gold_particles_2.visible = true
	else:
		gold_particles_2.visible = false
	update_save_slot()
	
func update_save_slot() -> void:
	var idx = Global.current_slot_index
	var beaten := bosses_defeated(idx)
	var gold_count := gold_gems_earned(idx)
	
	
	gem.visible = beaten > 0
	gem.texture = GEM_TEXTURES[beaten - 1]
	
	if gold_count > 0:
		gold_gem.texture = GOLD_TEXTURES[gold_count - 1]
		gold_gem.visible = true
	else:
		gold_gem.visible = false
	##for i in range(3):
	#var tex := gem_texture_for(Global.current_slot_index)
	#if tex:
		#gem.texture = tex
		#gem.visible = true
	#else:
		#gem.visible = false
		
func gem_texture_for(slot_index:int) -> Texture2D:
	var data = Global.player_data_slots[slot_index]
	
	var gold_count = 0
	for flag in GOLD_BOSS_FLAGS:
		if data.get(flag) > 0.0:
			gold_count += 1
	
	if gold_count > 0 and gold_count <= 4:
		return GEM_TEXTURES[4 + gold_count]
		
	var beaten := bosses_defeated(slot_index)
		
	
	if beaten == 0:
		gem.visible = false
		return null
	if beaten >= 4: # and Global.player_data_slots[slot_index].game_clear
		return GEM_TEXTURES[4]
		
	return GEM_TEXTURES[beaten - 1]
	
func bosses_defeated(slot_index: int) -> int:
	var data = Global.player_data_slots[slot_index]
	var beaten := 0
	for flag in BOSS_FLAGS:
		if !data.get(flag):
			beaten += 1
	return beaten
	
func gold_gems_earned(slot_index: int) -> int:
	var data = Global.player_data_slots[slot_index]
	var count := 0
	for flag in GOLD_BOSS_FLAGS:
		if data.get(flag) > 0.0:
			count += 1
	return count

func _update_blade() -> void:
	var slot_data = Global.player_data_slots[Global.current_slot_index]
	var bosses_beaten = 0
	for i in range(1, 6):
		if !slot_data.get("first_play_%d" % i):
			bosses_beaten += 1
			
	bosses_beaten = clampi(bosses_beaten, 0, 4)
	gem.texture = GEM_TEXTURES[bosses_beaten]

func flash():
	blade.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()
	
func _on_flash_timer_timeout() -> void:
	blade.material.set_shader_parameter("flash_modifier", 0)

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
	if Global.player_data_slots[Global.current_slot_index].abyss_best_time_boss_5 <= 0.0:
		apply_knockback()
		knockback_effect.play("knockback_effect")
		knockback_audio.play()
		camera_shake()
				
func spawn_attack_vfx(attack_type: String):
	var particle_vfx = hit_particle.instantiate()
	particle_vfx.rotation = position.angle_to_point(player.position) + PI
	particle_vfx.hit_type = attack_type
	add_child(particle_vfx)
			
func apply_knockback():
	if player:
		player.apply_knockback(global_position, 350) #350 #175

func _on_knockback_effect_animation_finished() -> void:
	knockback_effect.rotation = randf() * TAU
	
func camera_shake():
	GlobalCount.camera.apply_shake(8.0, 15.0)
