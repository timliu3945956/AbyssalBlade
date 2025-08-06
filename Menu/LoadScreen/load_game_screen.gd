extends CanvasLayer

@export var next_scene : PackedScene
@export var batch_per_frame : int = 2
@export var grace_before_start := 1.0
@export var grace_after_done := 0.5

const LIST_PATH := "res://shader_precompile_list.txt"
const SENTINEL := "user://shader_warmup_done.flag"

@onready var cover : ColorRect = $ColorRect
@onready var pool : Node = $CompileParent

var _scene_queue : Array[String]
var _material_cache : Dictionary
var _live_compiles : int = 0
var _is_compat = ProjectSettings.get_setting("rendering/renderer/name") == "compatibility"

func _ready() -> void:
	cover.visible = true
	_material_cache = {}
	_load_list()
	await get_tree().create_timer(grace_before_start).timeout
	set_physics_process(true)
	
func _physics_process(_delta: float) -> void:
	#if _scene_queue.is_empty():
		#return
	if not _scene_queue.is_empty():
		var to_do = min(batch_per_frame, _scene_queue.size())
		for i in range(to_do):
			_compile_scene(_scene_queue.pop_back())
		
	if _scene_queue.is_empty() and _live_compiles == 0:
		_finish()
		
func _load_list() -> void:
	if FileAccess.file_exists(SENTINEL):
		print("[Shader-prep] Cache already primed, skipping warm-up.")
		call_deferred("_switch_scene")
		return
		
	var f := FileAccess.open(LIST_PATH, FileAccess.READ)
	if f == null:
		push_error("[Shader-prep] ERROR: Can't open %s" % LIST_PATH)
		_scene_queue = []
		return
		
	_scene_queue = []
	while not f.eof_reached():
		var line := f.get_line().strip_edges()
		if line != "":
			_scene_queue.append(line)
	f.close()
	_scene_queue.shuffle()
	print("[Shader-prep] Will compile", _scene_queue.size(), "scenes")
	
func _compile_scene(path: String) -> void:
	var ps : PackedScene = load(path)
	if ps == null: return
	
	var root : Node = ps.instantiate()
	_scan_node_tree(root)
	root.queue_free()
	
func _scan_node_tree(n : Node) -> void:
	if n is GPUParticles2D:
		_push_material(n.process_material)
	elif n is Node2D:
		_push_material(n.material)
	elif n is MultiMeshInstance2D:
		_push_material(n.material)
		
	for p in n.get_property_list():
		if not (p.usage & PROPERTY_USAGE_STORAGE):
			continue
		if p.type != TYPE_OBJECT:
			continue
		var val = n.get(p.name)
		if val is ShaderMaterial \
		or val is ParticleProcessMaterial \
		or val is CanvasItemMaterial:
			_push_material(val)
	
	for child in n.get_children():
		_scan_node_tree(child)
			
func _push_material(mat: Resource) -> void: #owner: Node,
	if mat == null: return
	
	var key
	if mat is Shader:
		var shim := ShaderMaterial.new()
		shim.shader = mat
		mat = shim
		key = "shader:" + str(mat.shader)
	else:
		key = mat.resource_path if mat.resource_path != "" else mat.get_instance_id()
	#var key = mat.resource_path if mat.resource_path != "" else mat.get_instance_id()
	
	if _material_cache.has(key): return
	
	#print(" scheduling:", key)
	_material_cache[key] = true
	
	var dummy : Node
	if mat is ParticleProcessMaterial:
		if _is_compat:
			dummy = CPUParticles2D.new()
		else:
			dummy = GPUParticles2D.new()
		dummy.process_material = mat
		dummy.one_shot = true
		dummy.emitting = true
	else:
		var s := Sprite2D.new()
		s.texture = PlaceholderTexture2D.new()
		s.material = mat
		dummy = s
	
	pool.add_child(dummy)
	_live_compiles += 1
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	dummy.queue_free()
	_live_compiles -= 1
	#print(" compiled:", mat)
	
func _finish() -> void:
	print("[Shader-prep] Done. Compiled", _material_cache.size(), "unique materials.")
	set_physics_process(false)
	
	await get_tree().create_timer(grace_after_done).timeout
	FileAccess.open(SENTINEL, FileAccess.WRITE).close()
	call_deferred("_switch_scene")
	
func _switch_scene() -> void:
	if next_scene == null:
		push_error("next_scene is not assigned!")
		return
	TransitionScreen.transition_splash()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(next_scene)
