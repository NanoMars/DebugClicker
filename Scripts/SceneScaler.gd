extends Node

var base_size: Vector2 = Vector2(1920, 1080)

func _ready() -> void:
	var node2d = get_parent()
	if node2d and node2d is Node2D:
		var parent_control = node2d.get_parent()
		if parent_control and parent_control is Control:
			parent_control.resized.connect(_on_parent_resized)
			_on_parent_resized()
		else:
			push_warning("The parent of the Node2D is not a Control node!")
	else:
		push_warning("This node's parent is not a Node2D!")

func _on_parent_resized() -> void:
	var node2d = get_parent()
	var parent_control = node2d.get_parent()
	if parent_control and parent_control is Control:
		var new_size: Vector2 = parent_control.size
		node2d.scale = Vector2(new_size.x / base_size.x, new_size.y / base_size.y)
	else:
		push_warning("Cannot scale Node2D because its parent is not a Control!")
