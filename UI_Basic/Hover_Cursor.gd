extends Node

@export var cursor: String = "Default"
@export var enable_disable_cursor: bool = true



@export var button: Node = self

var hover: bool = false
var holding: bool = false
var unique_id := str(Time.get_unix_time_from_system()) + "_" + str(get_instance_id())

func _ready() -> void:

	if (get_parent() is Button or get_parent() is TextureButton) && button == null:
		button = get_parent()


	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)
	button.connect("button_down", _on_pressed)
	button.connect("button_up", _on_released)

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
