extends Node

func _ready() -> void:
	await get_tree().process_frame 
	Global.game_starting_up = false