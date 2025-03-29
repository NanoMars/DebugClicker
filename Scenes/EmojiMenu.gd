extends Button

var emoji_container: HBoxContainer
var emoji_picker: Control
var cursor_pos: int = 0

func _ready():
	emoji_container = get_parent().get_node_or_null("EmojiContainer")
	emoji_picker = get_children()[0]
	emoji_picker.visible = false
	connect("pressed", _on_pressed)
	for emoji in emoji_picker.emoji_container.get_children():
		emoji.pressed.connect(func() -> void:_on_emoji_pressed(emoji))

func _on_pressed() -> void:
	emoji_picker.visible = true
	cursor_pos = 0
	
func _on_emoji_pressed(emoji: Button) -> void:
	if cursor_pos >= emoji_container.get_child_count():
		cursor_pos = 0
	emoji_container.get_children()[cursor_pos].texture = emoji.icon
	cursor_pos += 1
	
