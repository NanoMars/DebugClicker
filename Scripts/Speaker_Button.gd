extends Button

@export var volume_menu: Control

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	volume_menu.visible = false

func _on_button_pressed() -> void:
	if volume_menu:
		volume_menu.visible = not volume_menu.visible
