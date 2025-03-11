extends Control

@export var texture_button: TextureButton
@export var temp_display: TextureProgressBar
@export var cold: float = 19
@export var base_cooling_rate: float = 3.0
var cooling_rate = base_cooling_rate

var current_temp: float = 0
var cooling = false

func _ready():
	texture_button.connect("pressed", _on_texture_button_pressed)

func _process(delta: float) -> void:
	current_temp = max(current_temp - delta * cooling_rate, 0)
	if current_temp >= temp_display.max_value - 1:
		cooling = true
		texture_button.disabled = true
	elif current_temp <= cold:
		cooling = false
		texture_button.disabled = false
	temp_display.value = current_temp
	

func _on_texture_button_pressed():
	if cooling == false:
		current_temp += 1
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, 1 + Global.flags.get("Clicker_Multiplier", 0), 0.2)