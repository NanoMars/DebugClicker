extends TextureRect

@export var window: MarginContainer

func _ready() -> void:
	
	if window and window.has_meta("Icon"):
		texture = window.get_meta("Icon")
		
