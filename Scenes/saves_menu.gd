extends Control

@export var add_button: Button
@export var saves_vbox: VBoxContainer
@export var save_scene: PackedScene #Button with a label and stuff
@export var game_scene: PackedScene

var save_buttons: Array = []

func _ready():
	add_button.connect("pressed", _on_add_button_pressed)
	load_save_slots()

func _on_add_button_pressed() -> void:
	var dir = DirAccess.open("user://")
	var max_slot = -1
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("savegame_slot_") and file_name.ends_with(".json"):
				var slot_str = file_name.replace("savegame_slot_", "").replace(".json", "")
				var slot_val = int(slot_str)
				if slot_val > max_slot:
					max_slot = slot_val
			file_name = dir.get_next()
		dir.list_dir_end()
	var slot = max_slot + 1
	var default_name = "Save " + str(slot)
	Global.save_game(slot, default_name)
	
	var save_instance = save_scene.instantiate()
	save_instance.name_line_edit.text = default_name
	saves_vbox.add_child(save_instance)
	save_buttons.append(save_instance)
	save_instance.pressed.connect(func() -> void:
		_load_save(slot)
	)
	save_instance.x_button.pressed.connect(func() -> void:
		_delete_save(slot)
	)
	save_instance.name_line_edit.text_changed.connect(func(new_text): _on_name_changed(new_text, slot))

func _on_name_changed(new_text: String, slot: int) -> void:
	Global.update_save_name(slot, new_text)
	print("Slot ", slot, " name changed to ", new_text)

func _load_save(slot: int) -> void:
	Global.load_game(slot)
	get_tree().change_scene_to_packed(game_scene)

func _delete_save(slot: int) -> void:
	Global.delete_save(slot)
	load_save_slots()

func load_save_slots() -> void:
	# Clear existing save slot instances from the container
	for child in saves_vbox.get_children():
		saves_vbox.remove_child(child)
		child.queue_free()

	var dir = DirAccess.open("user://")
	if not dir:
		print("Could not open user:// directory")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var slots = []
	while file_name != "":
		if file_name.begins_with("savegame_slot_") and file_name.ends_with(".json"):
			var slot_str = file_name.replace("savegame_slot_", "").replace(".json", "")
			var slot = int(slot_str)
			slots.append(slot)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	slots.sort()
	var loaded_names = []
	for slot in slots:
		var save_instance = save_scene.instantiate()
		var save_name = Global.get_save_name(slot)
		if save_name == "":
			save_name = "Save " + str(slot)
		loaded_names.append(save_name)
		save_instance.name_line_edit.text = save_name
		saves_vbox.add_child(save_instance)
		save_buttons.append(save_instance)
		save_instance.pressed.connect(func() -> void:
			_load_save(slot)
		)
		save_instance.x_button.pressed.connect(func() -> void:
			_delete_save(slot)
		)
		save_instance.name_line_edit.text_changed.connect(func(new_text): _on_name_changed(new_text, slot))
	print("Loaded save names: ", loaded_names)
