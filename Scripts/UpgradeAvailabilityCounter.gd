extends Button

var parent

var content

var label: Label

var buttons: Array[Button] = []

func _ready() -> void:
	var index = get_index()
	parent = get_parent()
	content = parent.tab_contents[index]
	label = get_node("MarginContainer/Label")
	var upgrades_available_container = content.get_node("MarginContainer/VBoxContainer/MarginContainer/Upgrades_Available")
	for i in range(upgrades_available_container.get_child_count()):
		var button = upgrades_available_container.get_child(i)
		buttons.append(button)

func _process(_delta):
	var temp_can_afford = 0
	for button in buttons:
		if Global.money >= button.price && button.disabled == false && button.visible == true:
			temp_can_afford += 1
	label.text = str(temp_can_afford) if temp_can_afford > 0 else ""
