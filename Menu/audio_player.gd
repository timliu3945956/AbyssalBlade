extends AudioStreamPlayer2D

#const menu_music = preload("res://audio/music/main menu music (memory of the lost).wav")
#const battle_music = preload("res://audio/music/boss 1 music (loop-ready).wav")

var music_player: AudioStreamPlayer

#func _init():
	

func _ready():
	#var audio_settings = ConfigFileHandler.load_audio_settings()
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_settings.master_volume))
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_settings.sfx_volume))
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(audio_settings.music_volume))
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

func play_music(music_stream: AudioStream, volume_db = 0.0):
	if music_player.stream == music_stream and music_player.is_playing():
		return
		
	music_player.stop()
	music_player.stream = music_stream
	music_player.volume_db = volume_db
	music_player.play()
	#stream = music.stream
	#volume_db = volume
	
func fade_out_music(fade_duration):
	if music_player.is_playing():
		var tween = get_tree().create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		await tween.finished
		music_player.stop()
		#tween.queue_free()
	
func stop_music():
	music_player.stop()
	
func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.bus = "SFX"
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
