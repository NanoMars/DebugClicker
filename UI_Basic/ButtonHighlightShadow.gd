extends Panel

@export var highlight: Panel
var button: Button = get_parent() as Button

@export var highlight_style: StyleBoxFlat
@export var shadow_style: StyleBoxFlat
@export var highlight_style_reverse: StyleBoxFlat
@export var shadow_style_reverse: StyleBoxFlat

func _ready():
	button = get_parent() as Button
	if button and button is Button:
		button.button_down.connect(_on_button_pressed)
		button.button_up.connect(_on_button_released)

	self.add_theme_stylebox_override("panel", shadow_style)
	highlight.add_theme_stylebox_override("panel", highlight_style)

func _on_button_pressed():
	self.add_theme_stylebox_override("panel", shadow_style_reverse)
	highlight.add_theme_stylebox_override("panel", highlight_style_reverse)

func _on_button_released():
	self.add_theme_stylebox_override("panel", shadow_style)
	highlight.add_theme_stylebox_override("panel", highlight_style)
