extends Control

@export var texture: Texture

func _ready() -> void:
	var texture_rect = get_node_or_null("TextureRect")
	if texture_rect and texture_rect is TextureRect:
		texture_rect.texture = texture
