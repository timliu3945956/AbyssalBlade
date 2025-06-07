extends Control

const MUSIC: = {
	"1": {
		stream = preload("res://audio/music/ABYSSAL BLADE.wav"),
		db = -30.0,
		name = "ABYSSAL BLADE"
	},
	"2": {
		stream = preload("res://audio/music/FLEETING HOPE.wav"),
		db = -22.0,
		name = "FLEETING HOPE"
	},
	"3": {
		stream = preload("res://audio/music/DENIAL.wav"),
		db = -30.0,
		name = "DENIAL"
	},
	"4": {
		stream = preload("res://audio/music/ANGER.wav"),
		db = -25.0,
		name = "ANGER"
	},
	"5": {
		stream = preload("res://audio/music/boss 3 music (loop-ready).wav"),
		db = -30.0,
		name = "BARGAIN"
	},
	"6": {
		stream = preload("res://audio/music/DEPRESSION.wav"),
		db = -25.0,
		name = "DEPRESSION"
	},
	"7": {
		stream = preload("res://audio/music/Infinity Chasers (Fractal Dreamers).mp3"),
		db = -40.0,
		name = "YOU"
	},
	"8": {
		stream = preload("res://audio/music/Punishing Gray Raven OST - Holy Moonlight.mp3"),
		db = -30.0,
		name = "GRIEF"
	},
	"9": {
		stream = preload("res://audio/music/ACCEPTANCE.wav"),
		db = -20.0,
		name = "ACCEPTANCE"
	}
}

const UNLOCK_REQUIREMENT := {
	"3": 1, 
	"4": 2,
	"5": 3,
	"6": 4,
	"7": 5,
	"8": 6,
	"9": 6
}

@onready var _buttons_container: VBoxContainer = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer
@onready var click_vfx = preload("res://audio/sfx/Menu/click.mp3")

@onready var song_name: Label = $CanvasLayer/PlayLength/CenterContainer/SongName
@onready var progress_bar: ProgressBar = $CanvasLayer/PlayLength/ProgressBar
@onready var timestamp: Label = $CanvasLayer/PlayLength/Timestamp
@onready var total_length: Label = $CanvasLayer/PlayLength/TotalLength
@onready var mana_bar_fire: GPUParticles2D = $CanvasLayer/PlayLength/ProgressBar/ManaBarFire

var cur_length: float = 1.0

var player: CharacterBody2D
var interact_collision: CollisionShape2D
var anim_player: AnimationPlayer

var _last_icon_btn: Button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player.canvas_layer.visible = false
	for child in _buttons_container.get_children():
		if child is Button and child.name.begins_with("MusicButton"):
			var index := child.name.substr("MusicButton".length())
			
			if MUSIC.has(index):
				child.pressed.connect(_on_music_button_pressed.bind(index, child))
			#child.focus_entered.connect(_show_icon_on.bind(child))
			
			var locked := _is_locked(index)
			child.disabled = locked
			if locked:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				child.text = "???"
			else:
				child.mouse_filter = Control.MOUSE_FILTER_STOP
				child.text = MUSIC[index].name
				
			child.get_node("SoundPlay").visible = false
			if not locked:
				child.focus_entered.connect(_show_icon_on.bind(child))
	AudioPlayer.track_started.connect(_on_track_started)
	AudioPlayer.progress_changed.connect(_on_progress_changed)
	AudioPlayer.track_finished.connect(_on_track_finished)
	_restore_last_focus()
	_sync_with_current_track()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress_bar.value < 0.35:
		mana_bar_fire.visible = false
	else:
		mana_bar_fire.visible = true
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		interact_collision.disabled = false
		AudioPlayer.play_FX(click_vfx, 0)
		player.canvas_layer.visible = true
		GlobalCount.paused = false
		accept_event()
		queue_free()

func _on_music_button_pressed(index:String, btn: Button) -> void:
	_show_icon_on(btn)
	
	AudioPlayer.last_music_button = index
	AudioPlayer.play_FX(click_vfx, 0)
	AudioPlayer.stop_music(false)
	progress_bar.value = 0
	#anim_player.play("change_songs")
	
	#await get_tree().create_timer(0.1).timeout
	#var data = MUSIC[index]
	AudioPlayer.play_music(MUSIC[index].stream, MUSIC[index].db)
	song_name.text = MUSIC[index].name
	
func _on_track_started(len: float) -> void:
	cur_length = max(len, 0.01)
	total_length.text = _format_time(cur_length)
	_on_progress_changed(0)
	
func _on_progress_changed(pos: float) -> void:
	progress_bar.value = (pos / cur_length) * 100.0
	timestamp.text = _format_time(pos)
	
func _on_track_finished() -> void:
	progress_bar.value = 0
	
func _format_time(sec: float) -> String:
	var m := int(sec) / 60
	var s := int(sec) % 60
	return "%2d:%02d" % [m, s]
	
func _reset_ui() -> void:
	progress_bar.value = 0
	timestamp.text = "00:00"
	total_length.text = "--:--"
	song_name.text = "SELECT A TRACK"
	
func _sync_with_current_track() -> void:
	var mp := AudioPlayer.music_player
	if mp and mp.playing:
		var song_title := "UNKNOWN"
		for key in MUSIC:
			if MUSIC[key].stream == mp.stream:
				song_title = MUSIC[key].name
				break
				
		cur_length = max(mp.stream.get_length(), 0.01)
		song_name.text = song_title
		total_length.text = _format_time(cur_length)
		
		var pos := mp.get_playback_position()
		_on_progress_changed(pos)
	else:
		_reset_ui()
		
func _restore_last_focus() -> void:
	var idx := AudioPlayer.last_music_button
	if idx != "":
		var btn_path := "MusicButton" + idx
		var btn := _buttons_container.get_node_or_null(btn_path)
		if btn:
			btn.grab_focus()
			_show_icon_on(btn)
			return
	for child in _buttons_container.get_children():
		if child is Button:
			child.grab_focus()
			_show_icon_on(child)
			break
			
func _show_icon_on(btn: Button) -> void:
	if _last_icon_btn and is_instance_valid(_last_icon_btn):
		_last_icon_btn.get_node("SoundPlay").visible = false
		
	var icon := btn.get_node("SoundPlay")
	icon.visible = true
	_last_icon_btn = btn
	
func _is_locked(idx: String) -> bool:
	if not UNLOCK_REQUIREMENT.has(idx):
		return false
	var boss_no = UNLOCK_REQUIREMENT[idx]
	var slot = Global.player_data_slots[Global.current_slot_index]
	return slot.get("first_play_%d" % boss_no)

func _on_back_pressed() -> void:
	interact_collision.disabled = false
	AudioPlayer.play_FX(click_vfx, 0)
	GlobalCount.paused = false
	player.canvas_layer.visible = true
	queue_free()
