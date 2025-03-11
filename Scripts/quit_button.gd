extends Button


func _ready() -> void:
	connect("pressed", _quit_game)


func _quit_game():
	Global.save_and_quit()
