extends VSlider

# Exported variables for configuration
@export var bus_index: int = 0
@export var slider_midpoint: int = 50
@export var slider_max: int = 100
@export var mute_db: float = -80.0

func _ready() -> void:
    connect("value_changed", _on_value_changed)
    var current_db = AudioServer.get_bus_volume_db(bus_index)
    var current_amp = db_to_linear(current_db)
    value = clamp(current_amp * slider_midpoint, 0, slider_max)

func _on_value_changed(new_value: float) -> void:
    if new_value == 0:
        # When the slider is at 0, mute the bus by setting the mute_db value
        AudioServer.set_bus_volume_db(bus_index, mute_db)
    else:
        # Map the slider value (0-slider_max) to an amplitude factor where slider_midpoint is 1.0 and slider_max is 2.0
        var amplitude = new_value / slider_midpoint
        var db_value = linear_to_db(amplitude)
        AudioServer.set_bus_volume_db(bus_index, db_value)
