extends Node

var AppID = "3681370" #Official Build: 3681370 Demo: 3779030

func _init():
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	
func _ready():
	
	Steam.steamInit()
	
	#var manifest := ProjectSettings.globalize_path("res://ExportFolder/controller_config/game_actions_3681370.vdf")
	#var ok := Steam.setInputActionManifestFilePath(manifest)
	#if not ok:
		#push_error("Steam Input: bad manifest path: %s" % manifest)
	#Steam.inputInit()
	#Steam.enableDeviceCallbacks()
	#SteamControllerInput.init()
	
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("ERROR: Steam not running!")
		return
		
	print("Steam is running!")
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Username: ", str(name))
	

func _check_completionist():
	var total := Steam.getNumAchievements()
	
	for i in range(total):
		var name := Steam.getAchievementName(i)
		if name == "" or name == "AchieveAll":
			continue
			
		var info := Steam.getAchievement(name)
		if !info.ret or !info.achieved:
			return
			
	Steam.setAchievement("AchieveAll")
	Steam.storeStats()
