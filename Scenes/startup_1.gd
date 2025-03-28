extends Control

@export var label_1: Label
@export var label_2: Label
@export var logo: TextureRect

@export var loading_image: TextureRect

@export var logo_fade_time: float = 1.0

@export var time_after_logo_start_showing_text: float = 1.0

@export var line_min_time: float = 0.05
@export var line_max_time: float = 0.15

@export var new_scene: PackedScene

@export var show_loading_screen_time: float = 2.5

@export var label_2_flash_time: float = 0.5

@export var change_scene_time: float = 2

@export var blank_screen_time: float = 1

var flash_label_2 = true

var original_text_label_1: String
var original_text_label_2: String

func _ready():
	loading_image.visible = false
	label_2.visible = false
	original_text_label_1 = label_1.text
	label_1.text = ""
	logo.modulate.a = 0.0 

	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, logo_fade_time)
	await tween.finished
	await get_tree().create_timer(time_after_logo_start_showing_text).timeout
	
	var lines = original_text_label_1.split("\n")
	for line in lines:
		label_1.text += line + "\n"
		await get_tree().create_timer(randf_range(line_min_time, line_max_time)).timeout
	label_2.visible = true

	var loading_screen_timer = get_tree().create_timer(show_loading_screen_time)
	loading_screen_timer.connect("timeout", _on_show_loading_screen_timer_timeout)

	
	while flash_label_2:
		await get_tree().create_timer(label_2_flash_time).timeout
		label_2.visible = not label_2.visible
	label_2.visible = false

func _on_show_loading_screen_timer_timeout():
	flash_label_2 = false
	label_2.visible = false
	label_1.visible = false
	logo.visible = false
	await get_tree().create_timer(blank_screen_time).timeout
	print("Changing scene")
	loading_image.visible = true
	await get_tree().create_timer(change_scene_time).timeout
	get_tree().root.add_child(new_scene.instantiate())
	get_tree().current_scene.queue_free()
