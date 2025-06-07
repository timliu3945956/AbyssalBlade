extends Marker2D
@onready var hit_particles_1: AnimatedSprite2D = $HitParticles1
@onready var hit_particles_2: AnimatedSprite2D = $HitParticles2
@onready var surge_hit_particles: AnimatedSprite2D = $SurgeHitParticles
@onready var surge_hit_particles_2: AnimatedSprite2D = $SurgeHitParticles2

var hit_type: String
var fade_tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match hit_type:
		"normal":
			hit_particles_1.rotation = randf() * 360.0
			hit_particles_1.play("attack")
			#fade_tween = get_tree().create_tween()
			#fade_tween.tween_property(hit_particles_1, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		"heavy":
			hit_particles_2.rotation = randf() * 360.0
			hit_particles_2.play("heavy_attack")
			#fade_tween = get_tree().create_tween()
			#fade_tween.tween_property(hit_particles_2, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		"surge":
			surge_hit_particles.rotation = randf() * 360.0
			surge_hit_particles_2.rotation = randf() * 360.0
			surge_hit_particles_2.play("default")
			surge_hit_particles.play("default")
			#fade_tween = get_tree().create_tween()
			#fade_tween.tween_property(surge_hit_particles, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _on_hit_particles_1_animation_finished() -> void:
	queue_free()


func _on_hit_particles_2_animation_finished() -> void:
	queue_free()


func _on_surge_hit_particles_animation_finished() -> void:
	pass


func _on_surge_hit_particles_2_animation_finished() -> void:
	queue_free()
