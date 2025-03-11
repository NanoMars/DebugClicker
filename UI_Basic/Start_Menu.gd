extends Button

@export var start_menu: PanelContainer

func _ready() -> void:
	self.pressed.connect(_on_button_pressed)
	start_menu.visible = false

func _on_button_pressed() -> void:
	start_menu.visible = not start_menu.visible
