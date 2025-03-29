extends Node

signal button_pressed_signal
signal shop_item_bought
signal upgrade_bought
signal setting_updated(setting_name: String) 

var money: int = 8000
var automations_owned = {}
var upgrades_owned = {}
var upgrades_visible = {}
var flags = {}
var game_behaviour_flags = {}
var shop_prices = {} 
var settings = {}
var window_data = {}
var current_save_slot = -1
var game_starting_up = true 

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()

func save():
	if current_save_slot >= 0:
		var current_name = get_save_name(current_save_slot)
		save_game(current_save_slot, current_name)

func save_and_quit():
	var main_windows = get_tree().get_nodes_in_group("MainWindow")
	if main_windows.size() > 0:
		main_windows[0].save_window_data()
		await main_windows[0].window_data_saved
	save()
	if OS.get_name() != "Web":
		get_tree().quit()
	else:
		get_tree().change_scene_to_file("res://Scenes/Startup1.tscn")

func save_game(slot: int = 0, name: String = ""):
	if name == "":
		name = "Save " + str(slot)
	var file_path = "user://savegame_slot_%d.json" % slot
	var save_data = {
		"name": name,
		"money": money,
		"automations_owned": automations_owned,
		"upgrades_owned": upgrades_owned,
		"game_behaviour_flags": game_behaviour_flags,
		"upgrades_visible": upgrades_visible,
		"window_data": window_data,
		"shop_prices": shop_prices,
		"settings": settings,
	}
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	print("Game saved to slot ", slot)

func load_game(slot: int = 0):
	var file_path = "user://savegame_slot_%d.json" % slot
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var data = file.get_as_text()
		var json = JSON.new()
		if json.parse(data) == OK:
			var save_data = json.data
			money = save_data.get("money", 0)
			automations_owned = save_data.get("automations_owned", {})
			upgrades_owned = save_data.get("upgrades_owned", {})
			game_behaviour_flags = save_data.get("game_behaviour_flags", {})
			upgrades_visible = save_data.get("upgrades_visible", {})
			window_data = save_data.get("window_data", {})
			shop_prices = save_data.get("shop_prices", {}) 
			settings = save_data.get("settings", {}) 
			print("Game loaded from slot ", slot)
			current_save_slot = slot
		else:
			print("Error parsing save file: ", json.get_error_message())
	else:
		print("No save file found for slot ", slot)

func delete_save(slot: int) -> void:
	var file_name = "savegame_slot_%d.json" % slot
	var dir = DirAccess.open("user://")
	if dir:
		if dir.file_exists(file_name):
			var error = dir.remove(file_name)
			if error == OK:
				print("Save file for slot %d deleted." % slot)
			else:
				print("Failed to delete save file for slot %d." % slot)
		else:
			print("No save file found for slot ", slot)
	else:
		print("Failed to open user:// directory")

func update_save_name(slot: int, new_name: String) -> void:
	var file_path = "user://savegame_slot_%d.json" % slot
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var data = file.get_as_text()
		var json = JSON.new()
		if json.parse(data) == OK:
			var save_data = json.data
			file.close()
			save_data["name"] = new_name
			print("Save name updated for slot ", slot, " to ", new_name)
			file = FileAccess.open(file_path, FileAccess.WRITE)
			file.store_string(JSON.stringify(save_data))
			print("Save name updated for slot ", slot)
		else:
			print("Error parsing save file in update_save_name: ", json.get_error_message())
	else:
		print("No save file found for slot ", slot)

func get_save_name(slot: int) -> String:
	var file_path = "user://savegame_slot_%d.json" % slot
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var data = file.get_as_text()
		var json = JSON.new()
		if json.parse(data) == OK:
			var save_data = json.data
			file.close()
			if save_data.has("name"):
				return save_data["name"]
			else:
					return ""
		else:
			print("Error parsing save file in get_save_name: ", json.get_error_message())
			return ""
	else:
		return ""

func logout_user():
	var main_windows = get_tree().get_nodes_in_group("MainWindow")
	if main_windows.size() > 0:
		main_windows[0].save_window_data()
		await main_windows[0].window_data_saved
	save()
	current_save_slot = -1
	game_starting_up = true
	money = 0
	automations_owned = {}
	upgrades_owned = {}
	upgrades_visible = {}
	flags = {}
	game_behaviour_flags = {}
	shop_prices = {}
	settings = {}
	window_data = {}
	get_tree().change_scene_to_file("res://Scenes/Login.tscn")