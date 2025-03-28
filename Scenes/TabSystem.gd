extends HBoxContainer

@export var button_scene: PackedScene

@export var tab_buttons: Array[Texture] = []
@export var tab_contents: Array[Control] = []
@export var tab_scripts: Array[Script] = []

var button_list: Array[Button] = []

func _ready() -> void:
	for i in range(tab_buttons.size()):
		var btn = button_scene.instantiate() as Button
		btn.icon = tab_buttons[i]
		
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.icon_alignment = 1

		if i < tab_scripts.size() and tab_scripts[i]:
			btn.set_script(tab_scripts[i])

		add_child(btn)
		button_list.append(btn)  
		btn.connect("pressed", _on_tab_pressed.bind(i))
	_on_tab_pressed(0) 

func _on_tab_pressed(index: int) -> void:
	for i in range(tab_contents.size()):
		tab_contents[i].visible = (i == index) 
		button_list[i].disabled = (i == index)
	print("Tab ", index, " pressed.")
