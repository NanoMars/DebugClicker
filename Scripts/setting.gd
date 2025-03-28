extends HBoxContainer

@export var setting: String
@export var default: bool
@onready var switch: TextureButton = $TextureButton

func _ready() -> void:
	if not setting in Global.settings:
		Global.settings[setting] = default

	switch.button_pressed = Global.settings[setting]
	switch.toggled.connect(_on_check_button_toggled)

func _on_check_button_toggled(button_pressed: bool) -> void:
	Global.settings[setting] = button_pressed
	Global.emit_signal("setting_updated", setting)
