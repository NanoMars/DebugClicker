extends Control

@export var texture_button: TextureButton
@export var temp_display: TextureProgressBar
@export var cold: float = 19
@export var base_cooling_rate: float = 3.0
var cooling_rate = base_cooling_rate

var spring_position: float
var velocity: float = 0
@export var dampening: float = 0.5
@export var click_velocity_addition: float = 1
@export var base_spring_strength: float = 1
var starting_scale: float = 1
@export var max_scale: float = 3
@export var spring_out_of_bounds_multiplier: float = 3


var current_temp: float = 0
var cooling = false

func _ready():
	texture_button.connect("pressed", _on_texture_button_pressed)
	texture_button.scale = Vector2(1, 1)
	texture_button.pivot_offset = texture_button.size / 2

func _process(delta: float) -> void:
	current_temp = max(current_temp - delta * cooling_rate, 0)
	if current_temp >= temp_display.max_value - 1:
		cooling = true
		texture_button.disabled = true
	elif current_temp <= cold:
		cooling = false
		texture_button.disabled = false
	temp_display.value = current_temp

	var spring_strength = base_spring_strength * ((max(abs(spring_position) - max_scale, 0) * spring_out_of_bounds_multiplier) + 1)
	print(str((max(abs(spring_position) - max_scale, 0) + 1)) + " " + str(max_scale - abs(spring_position)))

	velocity += spring_position * spring_strength * -1 * delta
	velocity *= 1 - dampening
	spring_position += velocity * delta

	

	##TextureButton.scale.x = starting_scale + spring_position
	#TextureButton.scale.y = starting_scale + spring_position
	texture_button.scale = Vector2(starting_scale + spring_position, starting_scale + spring_position)
	

func _on_texture_button_pressed():
	velocity += click_velocity_addition
	if cooling == false:
		current_temp += 1
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, 1 + Global.flags.get("Clicker_Multiplier", 0), 0.2)
