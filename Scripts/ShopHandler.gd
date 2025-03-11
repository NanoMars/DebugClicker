extends VBoxContainer

@export var fade_duration: float = 1.0

func update_data() -> void:
	var buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
	
	for i in range(buttons.size()):
		var button = buttons[i]
		var name = button.get_meta("Name", null)
		
		if name:
			if name in Global.shop_prices:
				button.set_meta("Price", Global.shop_prices[name])
			else:
				Global.shop_prices[name] = button.get_meta("Price", null)
		
		var price = button.get_meta("Price", null)
		var price_label = button.price
		var items_owned = button.owned
		var shop_image = button.icon_rect
		
		if price or price == 0 and price_label is Label:
			price_label.text = "$" + str(price)
		if shop_image:
			var image = button.get_meta("Image", null)
			if image:
				shop_image.texture = image
		if name and items_owned:
			if Global.automations_owned.has(name):
				items_owned.text = str(Global.automations_owned[name])
			else:
				Global.automations_owned[name] = 0
				items_owned.text = "0"
		
		var should_be_visible = false
		if i == 0:
			should_be_visible = true
		else:
			var prev_button = buttons[i - 1]
			var prev_name = prev_button.get_meta("Name", null)
			if prev_name and Global.automations_owned.has(prev_name) and Global.automations_owned[prev_name] >= 1:
				should_be_visible = true
		
		if should_be_visible:
			if not button.visible or not button.has_meta("has_been_visible"):
				button.visible = true
				button.set_meta("has_been_visible", true)
				var current_modulate = button.modulate
				button.modulate = Color(current_modulate.r, current_modulate.g, current_modulate.b, 0)
				var tween = get_tree().create_tween()
				tween.tween_property(button, "modulate:a", 1.0, fade_duration)
			else:
				button.visible = true
		else:
			button.visible = false

func _ready() -> void:
	for button in get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))
	update_data()

func _on_button_pressed(button: Button) -> void:
	var price = button.get_meta("Price", null)
	var name = button.get_meta("Name", null)
	if price != null and name and price <= Global.money:
		Global.automations_owned[name] += 1
		Global.money -= price
		
		var new_price = price * 2
		button.set_meta("Price", new_price)
		Global.shop_prices[name] = new_price
		
		Global.emit_signal("shop_item_bought", name)
		update_data()
