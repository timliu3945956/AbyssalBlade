extends TextureButton

@onready var cooldown: TextureProgressBar = $Cooldown
@onready var key: Label = $Key
@onready var timer: Timer = $Timer

var skill = null

var change_key = "":
	set(value):
		change_key = value
		key.text = value
		
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_key = "1"
	cooldown.max_value = timer.wait_time
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cooldown.value = timer.time_left


func _on_pressed() -> void:
	if skill != null:
		skill.cast_skill(owner)
		
		timer.start()
		disabled = true
		set_process(true)


func _on_timer_timeout() -> void:
	disabled = false
	cooldown.value = 0
	set_process(false)
