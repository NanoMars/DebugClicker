extends Control

@export var task_container: VBoxContainer
@export var task: PackedScene
@export var end_task: Button
@export var timer_thing: Timer
@export var task_count: int = 5
@export var money_per_second: int = 300

@export var bug_text_color: Color = Color.RED

var task_names = [
  "tempname1",
  "tempname2",
  "tempname3",
  "tempname4",
  "tempname5",
]

var tasks = []
var selected_task: Node = null
var bugging_task: Dictionary = {}
var last_bugged_task: Dictionary = {}

func _ready() -> void:
	randomize()
	timer_thing.one_shot = true
	timer_thing.connect("timeout", func() -> void:
		_on_bug_timer_timeout()
	)
	end_task.connect("pressed", func() -> void:
		_on_end_task_pressed()
	)
	end_task.disabled = true
	for i in range(task_count):
		var new_task = task.instantiate()
		var select_button = new_task
		var color_rect = new_task.get_node("ColorRect")
		var name_label = new_task.get_node("HBoxContainer/Name")
		var memory_label = new_task.get_node("HBoxContainer/Memory")
		name_label.text = task_names[randi() % task_names.size()]
		var init_memory = randf_range(50, 500)
		var rounded_memory = round(init_memory * 10) / 10.0
		memory_label.text = str(rounded_memory).replace(".", ",") + " K"
		color_rect.visible = false
		select_button.connect("pressed", func() -> void:
			_on_task_button_pressed(new_task)
		)
		task_container.add_child(new_task)
		var original_name_color = name_label.get_theme_color("font_color", "Label")
		var original_memory_color = memory_label.get_theme_color("font_color", "Label")
		tasks.append({
			"node": new_task,
			"name_label": name_label,
			"memory_label": memory_label,
			"color_rect": color_rect,
			"select_button": select_button,
			"bugging": false,
			"hidden": false,
			"original_name_color": original_name_color,
			"original_memory_color": original_memory_color
		})
	_start_bug_timer()
	_spawn_cycle()

func _process(delta: float) -> void:
	for t in tasks:
		if t["hidden"]:
			continue
		var new_memory = 0.0
		if t["bugging"]:
			new_memory = randf_range(800, 1500)
			t["name_label"].add_theme_color_override("font_color", bug_text_color)
			t["memory_label"].add_theme_color_override("font_color", bug_text_color)
		else:
			new_memory = randf_range(50, 500)
			t["name_label"].add_theme_color_override("font_color", t["original_name_color"])
			t["memory_label"].add_theme_color_override("font_color", t["original_memory_color"])
		var rounded_memory = round(new_memory * 10) / 10.0
		t["memory_label"].text = str(rounded_memory).replace(".", ",") + " K"
	if selected_task:
		var st_data = _get_task_data_from_node(selected_task)
		if st_data.size() > 0 and st_data["bugging"]:
			end_task.disabled = false
		else:
			end_task.disabled = true
	else:
		end_task.disabled = true

func _on_bug_timer_timeout() -> void:
	var valid_tasks = []
	for t in tasks:
		if not t["hidden"] and t != last_bugged_task:
			valid_tasks.append(t)
	if valid_tasks.size() == 0:
		return
	var chosen_task = valid_tasks[randi() % valid_tasks.size()]
	chosen_task["bugging"] = true
	bugging_task = chosen_task

func _on_task_button_pressed(task_node: Node) -> void:
	var t_data = _get_task_data_from_node(task_node)
	if t_data.size() == 0:
		return
	if not t_data["bugging"]:
		return
	if selected_task == task_node:
		t_data["color_rect"].visible = false
		selected_task = null
	else:
		if selected_task:
			var prev_data = _get_task_data_from_node(selected_task)
			if prev_data.size() > 0:
				prev_data["color_rect"].visible = false
		t_data["color_rect"].visible = true
		selected_task = task_node

func _on_end_task_pressed() -> void:
	if not selected_task:
		return
	var st_data = _get_task_data_from_node(selected_task)
	if st_data.size() == 0:
		return
	if st_data["bugging"]:
		st_data["node"].visible = false
		st_data["hidden"] = true
		st_data["bugging"] = false
		last_bugged_task = st_data
		st_data["color_rect"].visible = false
		selected_task = null
		bugging_task = {}
		var num_spawns: int = int(10000 * pow(2, Global.flags.get("Task_Manager", 0)) * Global.automations_owned.get("Task Manager", 0)) 
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, num_spawns, 1)
		var hide_duration = randf_range(5, 10)
		var unhide_timer = Timer.new()
		unhide_timer.one_shot = true
		unhide_timer.wait_time = hide_duration
		unhide_timer.timeout.connect(Callable(self, "_on_unhide_task").bind(st_data))
		add_child(unhide_timer)
		unhide_timer.start()
		_start_bug_timer()

func _on_unhide_task(st_data: Dictionary) -> void:
	st_data["node"].visible = true
	st_data["hidden"] = false

func _spawn_cycle() -> void:
	if bugging_task.size() == 0:
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, money_per_second / 2 * pow(2, Global.flags.get("Task_Manager", 0)), 0.5)
	var multiplier: float = 1 + ((Global.automations_owned.get("Task Manager", 1) - 1) / 3.0)
	var timer = get_tree().create_timer(0.5 / multiplier)
	timer.timeout.connect(func() -> void:
		_spawn_cycle()
	)

func _start_bug_timer() -> void:
	timer_thing.wait_time = randf_range(20, 30)
	timer_thing.start()

func _get_task_data_from_node(node: Node) -> Dictionary:
	for t in tasks:
		if t["node"] == node:
			return t
	return {}
