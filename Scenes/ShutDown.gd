extends Button

func _ready() -> void:
	connect("pressed", _on_button_pressed)

func _on_button_pressed() -> void:
	Global.save_and_quit()