extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "089SADFH"

var player_data = PlayerData.new()

func _ready():
	verify_save_directory(SAVE_DIR)
	load_data(SAVE_DIR + SAVE_FILE_NAME)
	print("data loaded")
	
		
func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func save_data(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY) # Security key to encrypt data
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"player_data": {
			"boss_1": player_data.best_time_boss_1,
			"boss_2": player_data.best_time_boss_2,
			"boss_3": player_data.best_time_boss_3,
			"boss_4": player_data.best_time_boss_4,
			"boss_5": player_data.best_time_boss_5,
			#"cutscene_boss_1": player_data.cutscene_viewed_boss_1,
			#"cutscene_boss_2": player_data.cutscene_viewed_boss_2,
			#"cutscene_boss_3": player_data.cutscene_viewed_boss_3,
			#"cutscene_boss_4": player_data.cutscene_viewed_boss_4,
			#"cutscene_boss_5": player_data.cutscene_viewed_boss_5,
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
		}
	}
	print(data)
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	
func load_data(path: String):
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
		player_data = PlayerData.new()
		player_data.best_time_boss_1 = data.player_data.boss_1
		player_data.best_time_boss_2 = data.player_data.boss_2
		player_data.best_time_boss_3 = data.player_data.boss_3
		player_data.best_time_boss_4 = data.player_data.boss_4
		player_data.best_time_boss_5 = data.player_data.boss_5
		
		#player_data.cutscene_viewed_boss_1 = data.player_data.cutscene_boss_1
		#player_data.cutscene_viewed_boss_2 = data.player_data.cutscene_boss_2
		#player_data.cutscene_viewed_boss_3 = data.player_data.cutscene_boss_3
		#player_data.cutscene_viewed_boss_4 = data.player_data.cutscene_boss_4
		#player_data.cutscene_viewed_boss_5 = data.player_data.cutscene_boss_5
		
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
	else:
		printerr("Cannot open non_existent file at %s!" % [path])
	
func change_best_time(boss_number: int, time : float):
	var best_time_var = "best_time_boss_%d" % boss_number
	var current_best_time = player_data.get(best_time_var)
	if current_best_time == 0.0 or time < current_best_time:
		player_data.set(best_time_var, time)
		save_data(SAVE_DIR + SAVE_FILE_NAME)
