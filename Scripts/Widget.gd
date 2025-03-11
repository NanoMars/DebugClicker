extends Button

@export var widget: MarginContainer

var dragging: bool = false
var initial_mouse_pos: Vector2 = Vector2.ZERO
var initial_widget_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Connect the parent's "resized" signal (if available) to update the widget's position.
	var parent_control = widget.get_parent()
	if parent_control.has_signal("resized"):
		parent_control.connect("resized", _on_parent_resized)
	
	# Connect the button's pressed signal to start dragging.
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	# Begin dragging the widget.
	dragging = true
	initial_mouse_pos = get_viewport().get_mouse_position()
	initial_widget_position = widget.position

func _gui_input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# Stop dragging when the left mouse button is released.
			if not event.pressed:
				dragging = false
		elif event is InputEventMouseMotion:
			var current_mouse_pos = get_viewport().get_mouse_position()
			var delta = current_mouse_pos - initial_mouse_pos
			var new_pos = initial_widget_position + delta
			
			# Clamp the new position so that the widget stays within its parent's boundaries.
			var parent_control = widget.get_parent() as Control
			if parent_control:
				var parent_size = parent_control.size
				new_pos.x = clamp(new_pos.x, 0, parent_size.x - widget.size.x)
				new_pos.y = clamp(new_pos.y, 0, parent_size.y - widget.size.y)
			
			widget.position = new_pos

func _on_parent_resized() -> void:
	# When the parent is resized, ensure the widget remains within the visible area.
	clamp_position()

func clamp_position() -> void:
	var parent_control = widget.get_parent() as Control
	if parent_control:
		var parent_size = parent_control.size
		var p = widget.position
		p.x = clamp(p.x, 0, parent_size.x - widget.size.x)
		p.y = clamp(p.y, 0, parent_size.y - widget.size.y)
		widget.position = p
