extends MarginContainer

@export var window_to_scale: MarginContainer

@export var L: Button
@export var R: Button
@export var T: Button
@export var B: Button
@export var TL: Button
@export var TR: Button
@export var BL: Button
@export var BR: Button

@export var grabber: Button

var dragging: bool = false
var active_button: String = ""
var initial_mouse_pos: Vector2 = Vector2.ZERO
var initial_window_pos: Vector2 = Vector2.ZERO
var initial_window_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	var parent_node = window_to_scale.get_parent()
	if parent_node.has_signal("resized"):
		parent_node.connect("resized", Callable(self, "_on_parent_resized"))
	
	grabber.pressed.connect(func() -> void: start_drag("grabber"))
	
	L.pressed.connect(func() -> void: start_drag("L"))
	R.pressed.connect(func() -> void: start_drag("R"))
	T.pressed.connect(func() -> void: start_drag("T"))
	B.pressed.connect(func() -> void: start_drag("B"))
	TL.pressed.connect(func() -> void: start_drag("TL"))
	TR.pressed.connect(func() -> void: start_drag("TR"))
	BL.pressed.connect(func() -> void: start_drag("BL"))
	BR.pressed.connect(func() -> void: start_drag("BR"))

func start_drag(button_name: String) -> void:
	dragging = true
	active_button = button_name
	initial_mouse_pos = get_viewport().get_mouse_position()
	initial_window_pos = window_to_scale.position
	initial_window_size = window_to_scale.size
	print("Started dragging with ", button_name, " | Mouse: ", initial_mouse_pos, " | Pos: ", initial_window_pos, " | Size: ", initial_window_size)

func _process(delta: float) -> void:
	if dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging = false
			active_button = ""
			return

		var current_mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var new_pos: Vector2 = initial_window_pos
		var new_size: Vector2 = initial_window_size

		match active_button:
			"grabber":
				new_pos = initial_window_pos + (current_mouse_pos - initial_mouse_pos)
			"L":
				var diff: float = initial_mouse_pos.x - current_mouse_pos.x
				new_size.x = initial_window_size.x + diff
				new_pos.x = initial_window_pos.x - diff
			"R":
				var diff: float = current_mouse_pos.x - initial_mouse_pos.x
				new_size.x = initial_window_size.x + diff
			"T":
				var diff: float = initial_mouse_pos.y - current_mouse_pos.y
				new_size.y = initial_window_size.y + diff
				new_pos.y = initial_window_pos.y - diff
			"B":
				var diff: float = current_mouse_pos.y - initial_mouse_pos.y
				new_size.y = initial_window_size.y + diff
			"TL":
				var diff_x: float = initial_mouse_pos.x - current_mouse_pos.x
				var diff_y: float = initial_mouse_pos.y - current_mouse_pos.y
				new_size.x = initial_window_size.x + diff_x
				new_size.y = initial_window_size.y + diff_y
				new_pos.x = initial_window_pos.x - diff_x
				new_pos.y = initial_window_pos.y - diff_y
			"TR":
				var diff_x: float = current_mouse_pos.x - initial_mouse_pos.x
				var diff_y: float = initial_mouse_pos.y - current_mouse_pos.y
				new_size.x = initial_window_size.x + diff_x
				new_size.y = initial_window_size.y + diff_y
				new_pos.y = initial_window_pos.y - diff_y
			"BL":
				var diff_x: float = initial_mouse_pos.x - current_mouse_pos.x
				var diff_y: float = current_mouse_pos.y - initial_mouse_pos.y
				new_size.x = initial_window_size.x + diff_x
				new_size.y = initial_window_size.y + diff_y
				new_pos.x = initial_window_pos.x - diff_x
			"BR":
				var diff_x: float = current_mouse_pos.x - initial_mouse_pos.x
				var diff_y: float = current_mouse_pos.y - initial_mouse_pos.y
				new_size.x = initial_window_size.x + diff_x
				new_size.y = initial_window_size.y + diff_y
			_:
				pass

		var min_size: Vector2 = window_to_scale.custom_minimum_size
		if active_button in ["L", "TL", "BL"]:
			if new_size.x < min_size.x:
				new_size.x = min_size.x
				new_pos.x = initial_window_pos.x - (min_size.x - initial_window_size.x)
		else:
			new_size.x = max(new_size.x, min_size.x)
			
		if active_button in ["T", "TL", "TR"]:
			if new_size.y < min_size.y:
				new_size.y = min_size.y
				new_pos.y = initial_window_pos.y - (min_size.y - initial_window_size.y)
		else:
			new_size.y = max(new_size.y, min_size.y)

		var parent_size: Vector2 = window_to_scale.get_parent().size

		var half_width: float = new_size.x / 2
		if new_pos.x < -half_width:
			new_pos.x = -half_width
		if new_pos.x + new_size.x > parent_size.x + half_width:
			new_pos.x = parent_size.x + half_width - new_size.x

		if new_pos.y < 0:
			new_pos.y = 0
		if new_pos.y > parent_size.y - 16:
			new_pos.y = parent_size.y - 16

		var parent_node = window_to_scale.get_parent()
		parent_node.move_child(window_to_scale, parent_node.get_child_count() - 1)

		window_to_scale.position = new_pos
		window_to_scale.size = new_size

func _on_parent_resized() -> void:
	clamp_window()

func clamp_window() -> void:
	var parent_size: Vector2 = window_to_scale.get_parent().size
	var pos: Vector2 = window_to_scale.position
	var size: Vector2 = window_to_scale.size
	var half_width: float = size.x / 2

	if pos.x < -half_width:
		pos.x = -half_width
	if pos.x + size.x > parent_size.x + half_width:
		pos.x = parent_size.x + half_width - size.x

	if pos.y < 0:
		pos.y = 0
	if pos.y > parent_size.y - 16:
		pos.y = parent_size.y - 16

	window_to_scale.position = pos
