extends Label

@export var label: Label  
@export var speed: float = 50.0  
@export var direction: Vector2 = Vector2(1, 0)  

var start_position: Vector2

func _ready():
	if label:
		start_position = label.position  

func _process(delta):
	if label:
		label.position += direction * speed * delta  
