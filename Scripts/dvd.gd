extends Control

@export var logo: TextureRect
@export var base_max_speed: Vector2 = Vector2(200, 200)
@export var button: Button
@export var money_per_bounce: int = 12

var direction: Vector2 = Vector2(1, 1)
var speed: float

func _ready() -> void:
	connect("resized", _on_resized)
	button.connect("pressed", _increase_speed)
	speed = 30 if Global.game_behaviour_flags.get("DVD", true) else 0
	Global.game_behaviour_flags["DVD"] = false
		

func _process(delta: float) -> void:
	speed = max(speed - delta * (5 / (Global.flags.get("DVD_Upgrade_1", 0) + 1)), 0)
	var upgrade_bonus = base_max_speed * Global.automations_owned.get("DVD", 0)
	var effective_max_speed = base_max_speed + upgrade_bonus
	speed = min(speed, effective_max_speed.x)
	var new_position = logo.position + direction * speed * delta
	logo.position = bounce_position(new_position)

func bounce_position(new_position: Vector2) -> Vector2:
	var max_x = size.x - logo.size.x
	var max_y = size.y - logo.size.y

	if new_position.x < 0 or new_position.x > max_x:
		direction.x *= -1
		new_position.x = clamp(new_position.x, 0, max_x)
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, money_per_bounce * pow(2, Global.flags.get("DVD_Upgrade_2", 0)), 0.05)
	
	if new_position.y < 0 or new_position.y > max_y:
		direction.y *= -1
		new_position.y = clamp(new_position.y, 0, max_y)
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, money_per_bounce * pow(2, Global.flags.get("DVD_Upgrade_2", 0)), 0.05)
	
	return new_position

func _on_resized() -> void:
	var max_x = size.x - logo.size.x
	var max_y = size.y - logo.size.y
	logo.position = Vector2(clamp(logo.position.x, 0, max_x), clamp(logo.position.y, 0, max_y))

func _increase_speed() -> void:
	speed += Global.automations_owned.get("DVD", 1) * 100
