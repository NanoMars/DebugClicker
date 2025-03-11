extends HBoxContainer

@export var shop_items: Dictionary[String, Array]
@export var button: PackedScene
@export var button_script: Script
@export var window_scene: PackedScene
@export var spacer: Control

func _ready() -> void:
	if Global.has_signal("shop_item_bought"):
		Global.connect("shop_item_bought", _on_shop_item_bought)

	for name in Global.automations_owned.keys():
		if Global.automations_owned[name] >= 1:
			_on_shop_item_bought(name)

func _on_shop_item_bought(name: String) -> void:
	if not shop_items.has(name):
		print("Item not found for: ", name)
		print(shop_items)
		return

	if get_node_or_null(name):
		print("Button for ", name, " already exists.")
		return

	var item_data = shop_items[name]
	var btn = button.instantiate()
	btn.name = name
	btn.icon = item_data[0]
	btn.set_script(button_script)
	btn.content = item_data[1]
	btn.window_scene = window_scene
	
	if item_data.size() > 2 and item_data[2] != null:
		btn.window_custom_minumum_size = item_data[2]

	var index = spacer.get_index()
	add_child(btn)
	move_child(btn, index)
