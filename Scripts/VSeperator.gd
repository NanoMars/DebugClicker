extends Control

@export var texture: Texture


func _ready():
	if texture:
		var texture_rect: TextureRect = get_node("HBoxContainer/TextureRect")
		texture_rect.texture = texture
