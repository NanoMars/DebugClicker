extends Node2D

var dragged_body: RigidBody2D = null
var pin_joint: PinJoint2D = null
var dragger: StaticBody2D = null

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Mouse Pressed at:", event.position)
			_try_pick_body(event.position)
		else:
			print("Mouse Released")
			_release_body()
	elif event is InputEventMouseMotion and dragged_body:
		_move_dragger(event.position)

func _try_pick_body(mouse_pos: Vector2) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_bodies = true
	var result = space_state.intersect_point(query)
	
	if result.size() > 0:
		for hit in result:
			var body = hit.collider
			if body is RigidBody2D:
				print("Picked up:", body.name)
				dragged_body = body
				_attach_joint(mouse_pos)
				return
	print("No body found at", mouse_pos)

func _attach_joint(mouse_pos: Vector2) -> void:
	if dragged_body:
		dragger = StaticBody2D.new()
		dragger.name = "Dragger"
		dragger.global_position = mouse_pos
		get_tree().current_scene.add_child(dragger)
		
		pin_joint = PinJoint2D.new()
		pin_joint.global_position = mouse_pos
		get_tree().current_scene.add_child(pin_joint)
		pin_joint.node_a = dragged_body.get_path()
		pin_joint.node_b = dragger.get_path()
		print("Attached PinJoint2D at:", mouse_pos)

func _move_dragger(mouse_pos: Vector2) -> void:
	if dragger:
		dragger.global_position = mouse_pos
		print("Moved dragger to:", mouse_pos)

func _release_body() -> void:
	if pin_joint:
		print("Releasing:", dragged_body.name)
		pin_joint.queue_free()
		pin_joint = null
	if dragger:
		dragger.queue_free()
		dragger = null
	dragged_body = null
