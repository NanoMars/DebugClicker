extends Button

@export var target_area: Area2D  
@export var fruit_group: String = "fruits"  
@export var sprite: AnimatedSprite2D  

var juicing_time: float = 10.0  
var juicing_active: bool = false

func _ready():
	sprite.animation = "Idle"
	sprite.play()

func _pressed():
	if juicing_active:
		return  

	var fruits_inside := []
	for fruit in get_tree().get_nodes_in_group(fruit_group):
		if fruit is RigidBody2D and target_area.overlaps_body(fruit):
			fruits_inside.append(fruit)

	if fruits_inside.size() > 0:
		for fruit in fruits_inside:
			fruit.queue_free()  

		start_juicing()

func start_juicing():
	juicing_active = true
	sprite.animation = "Juicing"
	sprite.play()

	await get_tree().create_timer(juicing_time).timeout

	sprite.animation = "Idle"
	sprite.play()

	if Global.automations_owned.has("Juicer"):
		Global.clicks_left -= Global.automations_owned["Juicer"] * 3

	juicing_active = false

	get_tree().reload_current_scene()
