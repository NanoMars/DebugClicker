extends Control

@export var shop_item_to_hide: Button

func _ready() -> void:
	Global.connect("shop_item_bought", on_shop_item_bought)
	on_shop_item_bought("Clicker")
		
func on_shop_item_bought (_name: String):
	print("Shop item bought: " + _name + " " + str(Global.automations_owned.get(_name, 0)))
	if name == "Clicker" && Global.automations_owned.get("Clicker", 0) >= 1:
		shop_item_to_hide.queue_free()
		print("Hiding first shop item")
		disconnect("shop_item_bought", on_shop_item_bought)
