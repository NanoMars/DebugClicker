extends ScrollContainer

@export var wallpapers: Array[Texture]
var highlighted_wallpaper: Texture
var current_wallpaper: Texture

@export var wallpaper_switcher: HBoxContainer
@export var wallpaper_preview: TextureRect
@export var apply_button: Button

func _ready() -> void:
	for wallpaper in wallpapers:
		var wallpaper_button = TextureButton.new()
		wallpaper_button.texture_normal = wallpaper
		wallpaper_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		wallpaper_button.ignore_texture_size = true
		wallpaper_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		wallpaper_button.custom_minimum_size = Vector2(53, 30)

		wallpaper_switcher.add_child(wallpaper_button)
		wallpaper_button.pressed.connect(func() -> void: switch_wallpaper(wallpaper_button.texture_normal))
	apply_button.connect("pressed", _on_apply_button_pressed)
	
	if Global.settings.has("wallpaper"):
		var wallpaper_path = Global.settings["wallpaper"]
		if wallpaper_path is String:
			var wallpaper_texture = load(wallpaper_path)
			wallpaper_preview.texture = wallpaper_texture
	elif wallpapers.size() > 0:
		wallpaper_preview.texture = wallpapers[0]
	else: 
		wallpaper_preview.texture = Texture.new()
		

func switch_wallpaper(texture):
	wallpaper_preview.texture = texture
	highlighted_wallpaper = texture

func _on_apply_button_pressed() -> void:
	current_wallpaper = highlighted_wallpaper
	Global.settings["wallpaper"] = current_wallpaper.resource_path
	Global.emit_signal("setting_updated", "wallpaper")	
