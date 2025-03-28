extends Node

@export var click_down_sound: AudioStreamPlayer
@export var click_up_sound: AudioStreamPlayer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				click_down_sound.play()
			else:
				click_up_sound.play()

            