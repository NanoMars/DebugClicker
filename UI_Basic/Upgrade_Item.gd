extends Button

@export var owned_container: GridContainer

@export var price: int = 0
@export var flag_name: String
@export var upgrade_name: String
@export var upgrade_level: int = 1

@export_enum("Bool", "Int") var flag_type: String 

@export var description_icon: Texture
@export var description_text: String

@export var description_icon_reference: TextureRect
@export var description_text_reference: Label

func _ready() -> void:
	connect("pressed", _on_pressed)
	if Global.upgrades_owned.has(upgrade_name) && Global.upgrades_owned[upgrade_name] == true:
		get_parent().call_deferred("remove_child", self)
		owned_container.call_deferred("add_child", self)
		Global.flags[flag_name] = true if flag_type == "Bool" else Global.flags.get(flag_name, 0) + 1
		print("Upgrade already owned: " + upgrade_name)

	if description_icon_reference != null && description_icon != null:
		description_icon_reference.texture = description_icon
	if description_text_reference != null && description_text != "":
		description_text_reference.text = description_text

	var upgrade_level_label: Label = $"MarginContainer/Label" 
	upgrade_level_label.text = str(upgrade_level)

	if Global.upgrades_visible.get(upgrade_name, false):
		visible = true
	else:
		visible = false

func _on_pressed() -> void:
	if Global.money >= price:
		Global.money -= price

		Global.flags[flag_name] = true if flag_type == "Bool" else Global.flags.get(flag_name, 0) + 1
		Global.upgrades_owned[upgrade_name] = true
		get_parent().remove_child(self)
		owned_container.add_child(self)
		Global.emit_signal("upgrade_bought", upgrade_name)

func _process(_delta):
	if Global.upgrades_owned.has(upgrade_name) && Global.upgrades_owned[upgrade_name] == true:
		disabled = true
		visible = true
		return
	if Global.money >= price / 2:
		Global.upgrades_visible[upgrade_name] = true
		visible = true

	disabled = Global.money < price