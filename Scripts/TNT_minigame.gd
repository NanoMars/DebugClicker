extends Control

@export var dynamite_scene: PackedScene
@export var detonator: TextureButton
@export var counter_label: Label
@export var grid_container: GridContainer

func _ready():
	Global.connect("button_pressed_signal", _on_global_button_pressed)

	if detonator:
		detonator.connect("pressed", _on_detonate_pressed)
	else:
		push_warning("Detonator button not assigned!")

	_update_counter_label()
	if Global.has_signal("shop_item_bought"):
		Global.connect("shop_item_bought", Callable(self, "_on_shop_item_bought"))

func _on_global_button_pressed():
	if not dynamite_scene:
		push_warning("No dynamite scene assigned!")
		return
	
	var current_dynamite_count = get_tree().get_nodes_in_group("Dynamite").size()
	var max_dynamite = int(Global.automations_owned.get("TNT", 0) * 1.5 + 5)

	if current_dynamite_count < max_dynamite:
		var dynamite = dynamite_scene.instantiate()
		grid_container.add_child(dynamite)
		dynamite.global_position = Vector2(976, 183)
		dynamite.add_to_group("Dynamite")

	_update_counter_label()

func _on_detonate_pressed():
	var dynamite_list = get_tree().get_nodes_in_group("Dynamite")  
	var dynamite_count = dynamite_list.size()

	if dynamite_count > 0:
		Global.clicks_left -= dynamite_count 

		for dynamite in dynamite_list:
			dynamite.queue_free()
			await get_tree().process_frame
			print("Number dynamites: " + str(get_tree().get_nodes_in_group("Dynamite").size()))
			
		print("Detonated", dynamite_count, "dynamite(s). Reduced clicks_left by:", dynamite_count)
	
	_update_counter_label()
	
func _on_shop_item_bought(data):
	if data == "TNT":
		_update_counter_label()

func _update_counter_label():
	if counter_label:
		var current_dynamite_count = get_tree().get_nodes_in_group("Dynamite").size()
		print("current dynamite count: " + str(current_dynamite_count))
		var max_dynamite = int(Global.automations_owned.get("TNT", 0) * 1.5 + 5)
		grid_container.columns = ceil(sqrt(max_dynamite))
		counter_label.text = str(current_dynamite_count, "/", max_dynamite)
