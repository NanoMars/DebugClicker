extends Button

@export var price: Label
@export var owned: Label
@export var icon_rect: TextureRect

func _process(_delta: float) -> void:
	if Global.money >= get_meta("Price", 0):
		disabled = false
	else:
		disabled = true