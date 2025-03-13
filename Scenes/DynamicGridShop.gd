extends GridContainer

@export var object_to_check: Control = self

@export var column_size: int = 16

# on resize of self change columns
func _ready() -> void:
	object_to_check.connect("resized", update_columns)
	call_deferred("update_columns")

func update_columns() -> void:
	var h_sep = get_theme_constant("h_separation")
	var computed_columns = int((object_to_check.size.x - 2) / (column_size + h_sep))
	if computed_columns < 1:
		computed_columns = 1
	columns = computed_columns
	print("columns: ", columns)
