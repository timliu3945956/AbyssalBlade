extends Node

var AppID = "3681370" #3779030

func _init():
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	
func _ready():
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("ERROR: Steam not running!")
		return
		
	print("Steam is running!")
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Username: ", str(name))
