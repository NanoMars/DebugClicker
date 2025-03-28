extends Button

@export var window_scene: PackedScene
@export var content: PackedScene
@export var window_custom_minumum_size: Vector2 = Vector2(128,64)
@export var owned_at_start: bool = false

enum WindowState {
	HIDDEN,
	SHOWN,
	ANIMATING_SHOW,
	ANIMATING_HIDE
}

var state: int = WindowState.HIDDEN

var main_window: Control
var window_instance: Control = null
var last_window_location: Vector2 

var animating: bool = false
var visibility_goal: bool = false
var tween

var animation_duration: float = 0.15

var window_popup_min: float = 0.5
var window_popup_max: float = 1.5
	
func _ready() -> void:
	main_window = get_tree().get_nodes_in_group("MainWindow")[0]
	connect("pressed", _on_button_pressed)
	_on_button_pressed(true if Global.game_starting_up else false)

func _on_button_pressed(lag: bool = false) -> void:
	if window_instance == null:
		window_instance = window_scene.instantiate()
		window_instance.set_meta("Icon", self.icon)
		
		if window_custom_minumum_size:
			window_instance.custom_minimum_size = window_custom_minumum_size
		
		var file_path = content.resource_path
		var file_name = file_path.get_file()

		var settings = Global.window_data.get(file_name, {})
		if settings.has("size") and settings.has("position"):
			window_instance.size = Vector2(settings["size"]["x"], settings["size"]["y"])
			window_instance.position = Vector2(settings["position"]["x"], settings["position"]["y"])
		else:
			window_instance.custom_minimum_size = window_custom_minumum_size
			if owned_at_start:
				call_deferred("move_window_to_center")
			else:
				window_instance.position = get_viewport().get_mouse_position()
		last_window_location = window_instance.position
		
		
		state = WindowState.SHOWN if window_instance.visible else WindowState.HIDDEN

		window_instance.set_meta("unique_ID", file_name)

		var content_instance = content.instantiate()
		window_instance.add_child(content_instance)

		main_window.add_child(window_instance)


		window_instance.visible = false	
		if lag:
			await get_tree().create_timer(randf_range(window_popup_min, window_popup_max)).timeout 

		window_instance.visible = settings.get("visible", false if owned_at_start else true)
		return

	print("state: ", state)

	if state == WindowState.ANIMATING_SHOW:
		if tween:
			tween.kill()
			tween = null
		window_instance.visible = false
		window_instance.scale = Vector2(0, 0)
		state = WindowState.HIDDEN
		window_instance.position = last_window_location
		return

	if state == WindowState.ANIMATING_HIDE:
		if tween:
			tween.kill()
			tween = null
		window_instance.position = last_window_location
		window_instance.scale = Vector2(1, 1)
		state = WindowState.SHOWN
		return

	if state == WindowState.HIDDEN:
		window_instance.get_parent().move_child(window_instance, window_instance.get_parent().get_child_count() - 1)
		window_instance.visible = true
		window_instance.position = global_position
		window_instance.scale = Vector2(0, 0)
		tween = create_tween()
		state = WindowState.ANIMATING_SHOW
		tween.tween_property(window_instance, "position", last_window_location, animation_duration)
		tween.parallel().tween_property(window_instance, "scale", Vector2(1, 1), animation_duration)
		await tween.finished
		if state == WindowState.ANIMATING_SHOW: 
			state = WindowState.SHOWN
		tween = null
		return

	if state == WindowState.SHOWN:
		if window_instance.get_index() != window_instance.get_parent().get_child_count() - 1:
			window_instance.get_parent().move_child(window_instance, window_instance.get_parent().get_child_count() - 1)
			return
		last_window_location = window_instance.position
		tween = create_tween()
		state = WindowState.ANIMATING_HIDE
		tween.tween_property(window_instance, "position", global_position, animation_duration)
		tween.parallel().tween_property(window_instance, "scale", Vector2(0, 0), animation_duration)
		await tween.finished
		if state == WindowState.ANIMATING_HIDE:
			window_instance.visible = false
			state = WindowState.HIDDEN
		tween = null
		window_instance.position = last_window_location
		return

func move_window_to_center() -> void:
	window_instance.position = (Vector2(get_tree().get_root().get_node("BaseNode").size) / 2) - (window_instance.size / 2)
	last_window_location = window_instance.position
