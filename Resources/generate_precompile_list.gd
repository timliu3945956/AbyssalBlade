@tool
extends EditorScript

const SAVE_PATH := "res://shader_precompile_list.txt"

const MATERIAL_TYPES := [
	"ParticleProcessMaterial",
	"ShaderMaterial",
	"CanvasItemMaterial"
]

func _run() -> void:
	var scene_paths : PackedStringArray = _find_scenes_with_materials("res://")
	_write_list(scene_paths)
	print(
		"[Shader-prep] Wrote %d scene paths to %s" % [scene_paths.size(), SAVE_PATH]
	)

func _find_scenes_with_materials(root_dir: String) -> PackedStringArray:
	var matcher := RegEx.new()
	matcher.compile(
		'sub_resource|ext_resource.*type="(?:%s)"'
		% ("|".join(MATERIAL_TYPES))
	)
	
	var result : PackedStringArray
	var stack : Array[String] = [root_dir]
	
	while not stack.is_empty():
		var dir_path = stack.pop_back()
		var d := DirAccess.open(dir_path)
		if d == null: continue
		d.list_dir_begin()
		var f := d.get_next()
		while f != "":
			var full = dir_path + "/" + f
			if d.current_is_dir():
				if not f.begins_with("."):
					stack.push_back(full)
			elif f.get_extension().to_lower() in ["tscn", "scn"]:
				var txt := FileAccess.get_file_as_string(full)
				if matcher.search(txt) != null:
					result.append(full)
			f = d.get_next()
		d.list_dir_end()
		
	result.sort()
	return result
	
func _write_list(list: PackedStringArray) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	for p in list:
		file.store_line(p)
	file.close()
