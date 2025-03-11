extends GridContainer

@export var square_scene: PackedScene
@export var base_square_size := 40

var squares: Array = []

func _ready():
	columns = Global.current_square
	add_theme_constant_override("separation", 0)
	_update_grid(true)
	call_deferred("global_pos_grid_container")

func global_pos_grid_container():
	print("global pos grid container: " + str(global_position))

func _process(_delta):
	_update_grid(false)
	if columns != Global.current_square:
		columns = Global.current_square
		_update_grid(true)
	else:
		_update_grid(false)

func _update_grid(force_rebuild: bool):
	var total_cells = Global.current_square * Global.current_square
	var cell_size = size.x / Global.current_square
	var scale_factor = cell_size / base_square_size
	
	if force_rebuild or squares.size() != total_cells:
		for cell in squares:
			cell.queue_free()
		squares.clear()
		
		for i in range(total_cells):
			var new_square = square_scene.instantiate()
			new_square.scale = Vector2(scale_factor, scale_factor)
			add_child(new_square)
			squares.append(new_square)
	else:
		for cell in squares:
			cell.scale = Vector2(scale_factor, scale_factor)
	
	for i in range(squares.size()):
		if i < Global.clicks_left:
			squares[i].modulate = Color(1, 1, 1, 1)
		else:
			squares[i].modulate = Color(1, 1, 1, 0)
