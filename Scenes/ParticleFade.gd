extends Sprite2D

@export var fade_duration: float = 5.0


var fade_tween: Tween

func _start_fade() -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	modulate.a = 0.0
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_duration)
	print("Fading in...", get_parent().get_name())
