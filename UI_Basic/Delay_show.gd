extends Node

@export var delay_time: float = 0.5
@export var delay_time_random: float = 0.5

func _ready():
	print(self.visible)
	if not self.visible:
		return
	self.visible = false
	await get_tree().create_timer(randf_range(delay_time - (delay_time_random / 2), delay_time + (delay_time_random / 2))).timeout
	self.visible = true
		
