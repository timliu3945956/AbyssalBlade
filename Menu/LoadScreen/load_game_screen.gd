extends CanvasLayer

signal finished

@export var load_scene : PackedScene = preload("res://Menu/SplashScreenManager.tscn")
@export var compile_parent_path : NodePath = ^"CompileParent"
@export var extra_scenes_to_scan : Array[PackedScene] = []
@export var frames_per_material : int = 1
@export var log_to_console : bool = true

var _materials := {}
var _gpu_particles : Array[Material] = []
var _compile_parent : Node2D
var _dummy_sprite : Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_compile_parent = try_get_node2d(compile_parent_path)
	if _compile_parent == null:
		_compile_parent = Node2D.new()
	if _compile_parent.get_parent() == null:
		add_child(_compile_parent)
	
	if extra_scenes_to_scan.is_empty():
		extra_scenes_to_scan = _gather_all_scenes()
	
	_scan_tree(get_tree().root)
	for ps in extra_scenes_to_scan:
		var inst := ps.instantiate()
		#add_child(inst)
		_scan_tree(inst)
		inst.queue_free()
		
	
			
	_dummy_sprite = Sprite2D.new()
	_dummy_sprite.texture = _white_px()
	_compile_parent.add_child(_dummy_sprite)
	
	await _prime_materials()
	await _prime_gpu_particles()
	if log_to_console:
		print("[Precompiler] Found %d materials, %d GPU-particles"
			% [_materials.size(), _gpu_particles.size()])
	emit_signal("finished")
	print("SHADER PRECOMPILATION DONE HERE")
	#ProjectSettings.set_setting("rendering/shaders/pipeline_cache/save_cache", false)
	#ProjectSettings.save()
	_dummy_sprite.queue_free()
	_compile_parent.queue_free()
	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(load_scene)
	
func _gather_all_scenes() -> Array[PackedScene]:
	var scenes : Array[PackedScene] = []
	var dir := DirAccess.open("res://")
	if dir == null:
		push_error("Precompiler: cannot open project root")
		return scenes
	dir.list_dir_begin()
	var file := dir.get_next()
	while file != "":
		var path := dir.get_current_dir() + "/" + file
		if file.ends_with(".tscn"):
			var ps := ResourceLoader.load(path)
			if ps is PackedScene:
				scenes.append(ps)
		elif DirAccess.dir_exists_absolute(path):
			scenes += _gather_sub_scenes(path)
		file = dir.get_next()
	dir.list_dir_end()
	return scenes
	
func _gather_sub_scenes(start_path : String) -> Array[PackedScene]:
	var subs : Array[PackedScene] = []
	var sub_dir := DirAccess.open(start_path)
	sub_dir.list_dir_begin()
	var entry := sub_dir.get_next()
	while entry != "":
		var path := start_path + "/" + entry
		if path.ends_with(".tscn"):
			var ps := ResourceLoader.load(path)
			if ps is PackedScene:
				subs.append(ps)
		#elif DirAccess.dir_exists_absolute(path):
			#subs += _gather_sub_scenes(path)
		entry = sub_dir.get_next()
	sub_dir.list_dir_end()
	return subs

func _scan_tree(node : Node) -> void:
	match node:
		Sprite2D, AnimatedSprite2D, NinePatchRect, CanvasItem:
			if node.material: _materials[node.material] = true
		CPUParticles2D:
			if node.process_material: _materials[node.process_material] = true
		GPUParticles2D:
			if node.process_material:
				var mat : Material = node.process_material
				if mat not in _gpu_particles:
					_gpu_particles.append(mat)
			
	for c in node.get_children():
		_scan_tree(c)
		
func _prime_materials() -> void:
	var index := 0
	for mat in _materials.keys():
		_dummy_sprite.material = mat
		await get_tree().process_frame
		if log_to_console:
			print("[Precompiler] Material %d / %d – %s"
				  % [index, _materials.size(), mat.resource_path])
		for _frame in range(frames_per_material):
			await get_tree().process_frame
		index += 1
		
func _prime_gpu_particles() -> void:
	var index := 0
	for src in _gpu_particles:
		var p := GPUParticles2D.new()
		p.process_material = src
		p.amount = 1
		#var p := src.duplicate()
		_compile_parent.add_child(p)
		p.emitting = true
		
		await get_tree().process_frame
		#await get_tree().process_frame
		p.emitting = false
		await get_tree().process_frame
		
		p.queue_free()
		index += 1
		if log_to_console:
			print("[Precompiler] GPU-Particles %d / %d primed"
				  % [index, _gpu_particles.size()])

func _white_px() -> Texture2D:
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	return ImageTexture.create_from_image(img)
	
func try_get_node2d(path: NodePath) -> Node2D:
	if has_node(path):
		return get_node(path) as Node2D
	else:
		return null
