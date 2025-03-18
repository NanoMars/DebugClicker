extends Button

var parent: Control 
var scroll_container: ScrollContainer
@export_enum("left", "right") var scroll_direction: String = "right"
var holding = false

func _ready():

	parent = get_parent()
	scroll_container = parent.get_node("ScrollContainer")
	button_down.connect(func() -> void: holding = true)

func _process(delta):
	if holding:
		if not button_pressed:
			holding = false
		elif scroll_direction == "left":
			scroll_container.scroll_horizontal -= 1
			print("Scrolling left by ", delta)
		elif scroll_direction == "right":
			scroll_container.scroll_horizontal += 1
			print("Scrolling right by ", delta * 100)	
	
