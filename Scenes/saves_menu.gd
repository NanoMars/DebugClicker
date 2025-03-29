extends Control

@export var add_button: Button
@export var saves_vbox: VBoxContainer
@export var save_scene: PackedScene
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
	var default_textures = ["res://Assets/Emojis/Emojiquestionmark.png", "res://Assets/Emojis/Emojiquestionmark.png", "res://Assets/Emojis/Emojiquestionmark.png"]
	Global.save_game(slot, default_textures)
	
	var save_instance = save_scene.instantiate()
	for i in range(save_instance.emoji_hbox.get_child_count()):
		var tex_rect = save_instance.emoji_hbox.get_child(i)
		if i < default_textures.size():
			tex_rect.texture = load(default_textures[i])
			print("Loaded default texture for slot ", slot, ": ", default_textures[i])
	saves_vbox.add_child(save_instance)
	save_buttons.append(save_instance)
	
	save_instance.pressed.connect(func() -> void:
		_load_save(slot)
	)
	save_instance.x_button.pressed.connect(func() -> void:
		_delete_save(slot)
	)

func _load_save(slot: int) -> void:
	Global.load_game(slot)
	get_tree().change_scene_to_packed(game_scene)

func _delete_save(slot: int) -> void:
	Global.delete_save(slot)
	load_save_slots()

func load_save_slots() -> void:
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
	for slot in slots:
		var save_instance = save_scene.instantiate()
		var textures = Global.get_save_textures(slot)
		if textures.size() == 0 or textures.size() != 3:
			textures = ["res://Assets/Emojis/Emojiquestionmark.png", "res://Assets/Emojis/Emojiquestionmark.png", "res://Assets/Emojis/Emojiquestionmark.png"]
		for i in range(save_instance.emoji_hbox.get_child_count()):
			var tex_rect = save_instance.emoji_hbox.get_child(i)
			if i < textures.size():
				tex_rect.texture = load(textures[i])
		saves_vbox.add_child(save_instance)
		save_buttons.append(save_instance)
		save_instance.pressed.connect(func() -> void:
			_load_save(slot)
		)
		save_instance.x_button.pressed.connect(func() -> void:
			_delete_save(slot)
		)
		print("Loaded save textures for slot ", slot, ": ", textures)
