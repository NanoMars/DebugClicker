extends PanelContainer
@export var add_button: Button
@export var subtract_button: Button
@export var count_label: Label
@export var cost_label: Label

func _ready() -> void:
	add_button.connect("pressed", _add_button)
	subtract_button.connect("pressed", _subtract_button)
	update_labels()

func _add_button() -> void:
	if Global.current_square < Global.max_square:
		Global.current_square += 1
		Global.clicks_left = Global.current_square * Global.current_square
		update_labels()
	elif Global.current_square == Global.max_square && Global.money >= (Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3):
		Global.money -= (Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3)
		Global.current_square += 1
		Global.max_square += 1
		Global.clicks_left = Global.current_square * Global.current_square
		update_labels()
	else:
		print("what the heck!!!")

func _subtract_button() -> void:
	if Global.current_square - 1 >= 1:
		Global.current_square -= 1
		Global.clicks_left = Global.current_square * Global.current_square
		update_labels()
			
func update_labels() -> void:
	count_label.text = str(Global.current_square) + "/" + str(Global.max_square)
	cost_label.text = str((Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3) * (Global.max_square + 3))
