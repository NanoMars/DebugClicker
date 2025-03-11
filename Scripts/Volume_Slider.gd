extends VSlider

func _ready() -> void:
	connect("value_changed", Callable(self, "_on_value_changed"))
	value = db_to_linear(AudioServer.get_bus_volume_db(0))

func _on_value_changed(new_value: float) -> void:
	var db_value = linear_to_db(new_value)
	AudioServer.set_bus_volume_db(0, db_value)
