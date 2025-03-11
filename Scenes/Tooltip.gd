extends PanelContainer

@export var price_label: Label

var button: Button





func _ready():
	button = get_parent()

	print(button.get_name())
	button.connect("mouse_entered", on_mouse_entered)
	button.connect("mouse_exited", on_mouse_exited)
	visible = false
	
	var price = button.price
	price_label.text = "$" + str(price)

func on_mouse_entered():
	visible = true

func on_mouse_exited():
	visible = false
	
func _process(_delta: float) -> void:
	if visible:
		var mouse_pos = get_viewport().get_mouse_position()
		set_position(mouse_pos)
