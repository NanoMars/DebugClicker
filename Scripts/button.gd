extends Button

func _ready():
	connect("pressed", _on_button_pressed)

func _on_button_pressed():
	Global.clicks_left -= 1
	print("money is: " + str(Global.money) + " clicks_left is: " + str(Global.clicks_left))

	Global.emit_signal("button_pressed_signal")
