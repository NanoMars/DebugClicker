extends TextureRect

func _ready():
	if Global.settings.has("wallpaper"):
		var wallpaper_path = Global.settings["wallpaper"]
		if wallpaper_path is String:
			var wallpaper_texture = load(wallpaper_path)
			texture = wallpaper_texture
	Global.connect("setting_updated", _on_setting_updated)

func _on_setting_updated(setting: String) -> void:
	if setting == "wallpaper" and Global.settings.has("wallpaper"):
		var wallpaper_path = Global.settings["wallpaper"]
		if wallpaper_path is String:
			var wallpaper_texture = load(wallpaper_path)
			texture = wallpaper_texture
