extends HBoxContainer

@export var setting: String
@export var default: bool
@onready var check_button: CheckButton = $CheckButton

func _ready() -> void:
	if setting in Global.settings:
		check_button.button_pressed = Global.settings[setting]
	else:
		Global.settings[setting] = default

	check_button.toggled.connect(_on_check_button_toggled)

func _on_check_button_toggled(button_pressed: bool) -> void:
	Global.settings[setting] = button_pressed
	Global.emit_signal("setting_updated", setting)
