extends Node

const SAVE_DIR = "user://savefiles/" #savefiles #savefiles_DEMO
const SECURITY_KEY = "089SADFH"

#var player_data = PlayerData.new()
var player_data_slots = [
	PlayerData.new(),
	PlayerData.new(),
	PlayerData.new()
]

# current "active slot index (0, 1, 2)
var current_slot_index = 0

func _ready():
	verify_save_directory(SAVE_DIR)
	
	for i in range(3):
		load_data(i) #SAVE_DIR + SAVE_FILE_NAME
	print("data loaded")
	
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)
	
func get_slot_save_path(slot_index: int) -> String:
	return "%ssave_%d.json" % [SAVE_DIR, slot_index]

func save_data(slot_index: int):
	var path = get_slot_save_path(slot_index)
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY) # Security key to encrypt data
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var player_data = player_data_slots[slot_index]
	var data = {
		"player_data": {
			"boss_1": player_data.best_time_boss_1,
			"boss_2": player_data.best_time_boss_2,
			"boss_3": player_data.best_time_boss_3,
			"boss_4": player_data.best_time_boss_4,
			"boss_5": player_data.best_time_boss_5,
			
			"abyss_best_time_boss_1": player_data.abyss_best_time_boss_1,
			"abyss_best_time_boss_2": player_data.abyss_best_time_boss_2,
			"abyss_best_time_boss_3": player_data.abyss_best_time_boss_3,
			"abyss_best_time_boss_4": player_data.abyss_best_time_boss_4,
			"abyss_best_time_boss_5": player_data.abyss_best_time_boss_5,
			
			"clear_count_1": player_data.clear_count_1,
			"clear_count_2": player_data.clear_count_2,
			"clear_count_3": player_data.clear_count_3,
			"clear_count_4": player_data.clear_count_4,
			"clear_count_5": player_data.clear_count_5,
			
			#first clear data
			"first_time_boss_1": player_data.first_play_1,
			"first_time_boss_2": player_data.first_play_2,
			"first_time_boss_3": player_data.first_play_3,
			"first_time_boss_4": player_data.first_play_4,
			"first_time_boss_5": player_data.first_play_5,
			"first_time_boss_6": player_data.first_play_6,
			
			"first_clear_time_1": player_data.first_clear_time_1,
			"first_clear_time_2": player_data.first_clear_time_2,
			"first_clear_time_3": player_data.first_clear_time_3,
			"first_clear_time_4": player_data.first_clear_time_4,
			"first_clear_time_5": player_data.first_clear_time_5,
			
			"attempt_count_1": player_data.attempt_count_1,
			"attempt_count_2": player_data.attempt_count_2,
			"attempt_count_3": player_data.attempt_count_3,
			"attempt_count_4": player_data.attempt_count_4,
			"attempt_count_5": player_data.attempt_count_5,
			"time_played": player_data.time_played,
			"final_boss_cutscene": player_data.final_boss_cutscene,
			"first_cutscene": player_data.first_cutscene,
			"deaths": player_data.deaths,
			"surge_count": player_data.surge_count,
			"last_shown_stage": player_data.last_shown_stage,
			"demo_done": player_data.demo_done,
			"abyss_mode_popup": player_data.abyss_mode_popup,
			"gold_portal": player_data.gold_portal
		}
	}
	print(data)
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	
func load_data(slot_index: int):
	var path = get_slot_save_path(slot_index)
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
			
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
			return
		print(data)
		var player_data = PlayerData.new()
		player_data = PlayerData.new()
		player_data.best_time_boss_1 = data.player_data.boss_1
		player_data.best_time_boss_2 = data.player_data.boss_2
		player_data.best_time_boss_3 = data.player_data.boss_3
		player_data.best_time_boss_4 = data.player_data.boss_4
		player_data.best_time_boss_5 = data.player_data.boss_5
		
		player_data.abyss_best_time_boss_1 = data.player_data.abyss_best_time_boss_1
		player_data.abyss_best_time_boss_2 = data.player_data.abyss_best_time_boss_2
		player_data.abyss_best_time_boss_3 = data.player_data.abyss_best_time_boss_3
		player_data.abyss_best_time_boss_4 = data.player_data.abyss_best_time_boss_4
		player_data.abyss_best_time_boss_5 = data.player_data.abyss_best_time_boss_5
		
		player_data.clear_count_1 = data.player_data.clear_count_1
		player_data.clear_count_2 = data.player_data.clear_count_2
		player_data.clear_count_3 = data.player_data.clear_count_3
		player_data.clear_count_4 = data.player_data.clear_count_4
		player_data.clear_count_5 = data.player_data.clear_count_5
		
		player_data.first_play_1 = data.player_data.first_time_boss_1
		player_data.first_play_2 = data.player_data.first_time_boss_2
		player_data.first_play_3 = data.player_data.first_time_boss_3
		player_data.first_play_4 = data.player_data.first_time_boss_4
		player_data.first_play_5 = data.player_data.first_time_boss_5
		player_data.first_play_6 = data.player_data.first_time_boss_6
		
		player_data.first_clear_time_1 = data.player_data.first_clear_time_1
		player_data.first_clear_time_2 = data.player_data.first_clear_time_2
		player_data.first_clear_time_3 = data.player_data.first_clear_time_3
		player_data.first_clear_time_4 = data.player_data.first_clear_time_4
		player_data.first_clear_time_5 = data.player_data.first_clear_time_5
		
		player_data.attempt_count_1 = data.player_data.attempt_count_1
		player_data.attempt_count_2 = data.player_data.attempt_count_2
		player_data.attempt_count_3 = data.player_data.attempt_count_3
		player_data.attempt_count_4 = data.player_data.attempt_count_4
		player_data.attempt_count_5 = data.player_data.attempt_count_5
		
		player_data.time_played = data.player_data.time_played
		
		player_data.final_boss_cutscene = data.player_data.final_boss_cutscene
		player_data.first_cutscene = data.player_data.first_cutscene
		player_data.deaths = data.player_data.deaths
		player_data.surge_count = data.player_data.surge_count
		player_data.last_shown_stage = data.player_data.last_shown_stage
		player_data.demo_done = data.player_data.demo_done
		
		player_data.abyss_mode_popup = data.player_data.abyss_mode_popup
		player_data.gold_portal = data.player_data.gold_portal
		
		player_data_slots[slot_index] = player_data
	else:
		printerr("Cannot open non_existent file at %s!" % [path])
		
func abyss_stage_for(slot:int) -> int:
	var stage := 0
	var data = Global.player_data_slots[slot]
	if data.abyss_best_time_boss_1 > 0.0: stage = 1
	if data.abyss_best_time_boss_2 > 0.0: stage = 2
	if data.abyss_best_time_boss_3 > 0.0: stage = 3
	if data.abyss_best_time_boss_4 > 0.0: stage = 4
	return stage
	
func story_stage_for(slot:int) -> int:
	var stage := 0
	var data = Global.player_data_slots[slot]
	if !data.first_play_1: stage = 1
	if !data.first_play_2: stage = 2
	if !data.first_play_3: stage = 3
	if !data.first_play_4: stage = 4
	return stage

func slot_exists(slot_index: int) -> bool:
	return FileAccess.file_exists(get_slot_save_path(slot_index))
	
func delete_data(slot_index: int) -> void:
	var path := get_slot_save_path(slot_index)
	
	if FileAccess.file_exists(path):
		var err := DirAccess.remove_absolute(path)
		if err != OK:
			push_error("Couldn't delete %s (err %d)" % [path, err])
			return
		print("Save slot %d wiped." % slot_index)
	else:
		print("Save slot %d is already empty." % slot_index)
		
	player_data_slots[slot_index] = PlayerData.new()
