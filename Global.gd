extends Node

signal button_pressed_signal
signal shop_item_bought
signal upgrade_bought
signal setting_updated(setting_name: String) 

var money: int = 500000
var automations_owned = {}
var upgrades_owned = {}
var upgrades_visible = {}
var flags = {}
var game_behaviour_flags = {}
var shop_prices = {} 
var settings = {}
var window_data = {}

func _ready():
	get_tree().set_auto_accept_quit(false)
	load_game()
	print("settings: " + str(settings))

func _process(_delta):
	pass

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()
		
		
func save_and_quit():
	var main_windows = get_tree().get_nodes_in_group("MainWindow")
	if main_windows.size() > 0:
		main_windows[0].save_window_data()
		await main_windows[0].window_data_saved
	save_game()
	get_tree().quit()

func save_game():
	var save_data = {
		"money": money,
		"automations_owned": automations_owned,
		"upgrades_owned": upgrades_owned,
		"game_behaviour_flags": game_behaviour_flags,
		"upgrades_visible": upgrades_visible,
		"window_data": window_data,
		"shop_prices": shop_prices,
		"settings": settings,
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	print("Game saved!")

func load_game():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
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
			print("Game loaded!")
		else:
			print("Error parsing save file: ", json.get_error_message())
