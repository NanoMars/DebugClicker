extends Button

@export var window_scene: PackedScene
@export var content: PackedScene
@export var window_custom_minumum_size: Vector2 = Vector2(128,64)

var main_window: Control
var window_instance: Control = null
	
func _ready() -> void:
	main_window = get_tree().get_nodes_in_group("MainWindow")[0]
	connect("pressed", _on_button_pressed)
	_on_button_pressed()
	window_instance.visible = false


func _on_button_pressed() -> void:
	if window_instance == null:
		window_instance = window_scene.instantiate()
		window_instance.set_meta("Icon", self.icon)
		
		if window_custom_minumum_size:
			window_instance.custom_minimum_size = window_custom_minumum_size
		
		var content_instance = content.instantiate()
		window_instance.add_child(content_instance)
		
		main_window.add_child(window_instance)
	else:
		window_instance.visible = not window_instance.visible
