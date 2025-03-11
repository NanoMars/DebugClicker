extends Button

var window: MarginContainer
func _ready() -> void:
	var current = self
	while !window:
		if current.get_parent().is_in_group("Window"):
			window = current.get_parent()
		else:
			current = current.get_parent()
	connect("pressed", _on_button_pressed)
	
	
func _on_button_pressed():
	window.visible = false
