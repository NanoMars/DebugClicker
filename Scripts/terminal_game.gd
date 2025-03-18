extends Control

signal either_button_pressed

@export var crash_timer: Timer
@export var reward_timer: Timer
@export var close_crash: Button
@export var show_crash: MarginContainer
@export var yap_timer: Timer
@export var error_sound: AudioStreamPlayer

var close_crash_2: Button

func _ready():
	close_crash_2 = show_crash.get_node("area/Control2/VBoxContainer/Control/HBoxContainer/Button") as Button	
	close_crash.pressed.connect(_on_any_close_pressed)
	close_crash_2.pressed.connect(_on_any_close_pressed)
	update_crash_timer_interval()
	crash_timer.timeout.connect(_on_crash_timer_timeout)
	update_reward_timer_interval()
	reward_timer.timeout.connect(_on_reward_timer_timeout)
	
		

func _on_any_close_pressed():
	emit_signal("either_button_pressed")

func update_crash_timer_interval():
	
	var upgrade_1_owned = Global.flags.get("Terminal_Upgrade_1", false)
	var interval: float
	if Global.game_behaviour_flags.get("Terminal_first_time", true):
		interval = randf_range(3, 6)
		Global.game_behaviour_flags["Terminal_first_time"] = false
	else:
		interval = randf_range(15 if upgrade_1_owned else 30, 20 if upgrade_1_owned else 40)
	crash_timer.wait_time = interval
	crash_timer.start()

func update_reward_timer_interval():
	var terminal_owned: float = Global.automations_owned.get("Terminal", 1)
	var interval: float = 1 / terminal_owned
	reward_timer.wait_time = max(interval, 0)
	reward_timer.start()

func _on_crash_timer_timeout():
	if not reward_timer.is_stopped():
		reward_timer.stop()
	if not yap_timer.is_stopped():
		yap_timer.stop()
	if error_sound:
		error_sound.play()
	show_crash.visible = true
	await self.either_button_pressed
	show_crash.visible = false
	yap_timer.start()
	update_reward_timer_interval()
	update_crash_timer_interval()

func _on_reward_timer_timeout():
	get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, 2 if Global.flags.get("Terminal_Upgrade_2", false) else 1, 0.3	)
	# spawn_control_node(global_position + size / 2, num_spawns, burst_duration)
	update_reward_timer_interval()
