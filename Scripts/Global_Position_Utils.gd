extends Node
class_name GlobalPositionUtils

static func get_custom_global_position(node: Node) -> Vector2:
	var global_pos: Vector2 = Vector2.ZERO
	var current: Node = node
	while current:
		if current is Node2D:
			global_pos += current.global_position
		elif current is Control:
			global_pos += current.global_position
			print("global_pos of " + str(current.name) + ": " + str(global_pos))
		current = current.get_parent()
	print("global_pos Final: " + str(global_pos))
	return global_pos
