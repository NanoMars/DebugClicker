extends VBoxContainer

func _ready():
	Global.connect("shop_item_bought", Callable(self, "_on_shop_item_bought"))
	_initialize_automations()

func _initialize_automations():
	for automation_name in Global.automations_owned.keys():
		if Global.automations_owned[automation_name] >= 1:
			var minigame = get_node_or_null(automation_name)
			if minigame and minigame.get_child_count() == 0:
				var minigame_scene = minigame.get_meta("Scene")
				if minigame_scene is PackedScene:
					var instance = minigame_scene.instantiate()
					minigame.add_child(instance)

func _on_shop_item_bought(shopName):
	var minigame = get_node_or_null(shopName)
	if minigame and minigame.get_child_count() == 0:
		var minigame_scene = minigame.get_meta("Scene")
		if minigame_scene is PackedScene:
			var instance = minigame_scene.instantiate()
			minigame.add_child(instance)
