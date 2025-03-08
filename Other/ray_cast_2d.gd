extends RayCast2D

@onready var casting_particles: GPUParticles2D = $CastingParticle
@onready var collision_particles_2: GPUParticles2D = $CollisionParticles
@onready var beam_particle_2d: GPUParticles2D = $BeamParticles2D


var is_casting: bool = false:
	set(value): 
		is_casting = value
		
		beam_particle_2d.emitting = is_casting
		casting_particles.emitting = is_casting
		
		if is_casting:
			appear()
		else:
			collision_particles_2.emitting = false
			disappear()
		set_physics_process(is_casting)

func _ready() -> void:
	is_casting = false
	turn_on_casting()
	
func turn_on_casting():
	is_casting = true
	await get_tree().create_timer(2).timeout
	is_casting = false

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	
	collision_particles_2.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles_2.global_rotation = get_collision_normal().angle()
		collision_particles_2.position = cast_point
		
	$Line2D.points[1] = cast_point
	beam_particle_2d.position = cast_point * 0.5
	beam_particle_2d.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
#func set_is_casting(cast: bool) -> void:
	#is_casting = cast
	#
	#if is_casting:
		#appear()
	#else:
		#disappear()
	#set_physics_process(is_casting)
	
func appear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 10.0, 0.2)

func disappear() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
