extends CanvasLayer

@onready var cursor_image = $CursorImage

@export var cursor_shapes: Dictionary[String, Texture] = {}
@export var cursor_default: String = "Default"

var cursor_buffer: Dictionary = {}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	cursor_image.global_position = get_viewport().get_mouse_position()
	var active_cursor = null

	var keys = cursor_buffer.keys()
	if keys.size() > 0:
		active_cursor = cursor_buffer[keys[0]]
	
	if active_cursor != null and cursor_shapes.has(active_cursor):
		cursor_image.texture = cursor_shapes[active_cursor]
	else:
		cursor_image.texture = cursor_shapes[cursor_default]

func set_cursor(cursor_name: String, adding: bool, unique_id: String) -> void:
	if adding and cursor_shapes.has(cursor_name):
		cursor_buffer[unique_id] = cursor_name
	elif not adding:
		cursor_buffer.erase(unique_id)
	else:
		print("cursor shape not found ", cursor_name)
