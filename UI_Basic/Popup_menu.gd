extends Button

@export var start_menu: Control	

var hovering: bool

func _ready() -> void:
	connect("pressed", _on_button_pressed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	start_menu.visible = false

func _on_button_pressed() -> void:
	start_menu.visible = not start_menu.visible

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos = get_viewport().get_mouse_position()
			var menu_pos = start_menu.global_position
			var menu_size = start_menu.size

			var is_inside = (
				mouse_pos.x >= menu_pos.x and mouse_pos.x <= menu_pos.x + menu_size.x and
				mouse_pos.y >= menu_pos.y and mouse_pos.y <= menu_pos.y + menu_size.y
			)
			if not event.pressed and not is_inside and start_menu.visible and not hovering:
				start_menu.visible = false
				print("click outside")

func _on_mouse_entered() -> void:
	hovering = true
func _on_mouse_exited() -> void:
	hovering = false
