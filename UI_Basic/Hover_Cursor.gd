extends Node

@export var cursor: String = "Default"
@export var enable_disable_cursor: bool = true



@export var button: Node = self

var hover: bool = false
var holding: bool = false
var unique_id := str(Time.get_unix_time_from_system()) + "_" + str(get_instance_id())

func _ready() -> void:

	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)
	if button is Button or button is TextureButton:
		button.connect("button_down", _on_pressed)
		button.connect("button_up", _on_released)
	else:
		enable_disable_cursor = false

func _on_mouse_entered() -> void:
	hover = true
	calculate_cursor()

func _on_mouse_exited() -> void:
	hover = false
	calculate_cursor()

func _on_pressed() -> void:
	holding = true
	calculate_cursor()

func _on_released() -> void:
	holding = false
	calculate_cursor()

func calculate_cursor() -> void:
	if enable_disable_cursor && button.disabled:
		if holding || hover:
			CustomCursor.set_cursor("Cross", true, unique_id)
		else:
			CustomCursor.set_cursor("Cross", false, unique_id)
	else:
		if holding || hover:
			CustomCursor.set_cursor(cursor, true, unique_id)
		else:
			CustomCursor.set_cursor(cursor, false, unique_id)
