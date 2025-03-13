extends Control
signal window_data_saved

func save_window_data() -> void:
	for child in get_children():
		var unique_ID = child.get_meta("unique_ID")
		var settings = Global.window_data.get(unique_ID, {})
		settings["size"] = { "x": child.size.x, "y": child.size.y }
		settings["position"] = { "x": child.position.x, "y": child.position.y }
		settings["visible"] = child.visible
		Global.window_data[unique_ID] = settings
	print("Window data saved!")
	emit_signal("window_data_saved")
