extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	set_block_signals(true)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100.0
	set_block_signals(false)
	
	value_changed.connect(_on_value_changed)
	
	#value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100
	
func _on_value_changed(value: float) -> void:
	var linear = clamp(value / 100.0, 0.0, 1.0)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(linear)
	)
	ConfigFileHandler.save_audio_setting(bus_name.to_lower() + "_volume", linear)
