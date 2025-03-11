extends Control

@export var control_node_scene: PackedScene
@export var spawn_parent_path: NodePath
@export var goal_node: Control
@export var acceleration_curve: Curve
@export var air_resistance: float = 0.1
@export var clump_interval: float = 1.0

var particle_pool: Array = []
var particles_enabled: bool = Global.settings.get("Particles_Enabled", true)

func _ready() -> void:
	Global.setting_updated.connect(_on_setting_updated)
	
func _on_setting_updated(setting_name: String) -> void:
	if setting_name == "Particles_Enabled":
		particles_enabled = Global.settings[setting_name]

func _spawn_single(start_position: Vector2, clump_count: int = 1) -> Control:
	var spawn_parent = get_node(spawn_parent_path)
	var particle_instance: Control = null
	
	if particle_pool.size() > 0:
		particle_instance = particle_pool.pop_back()
	else:
		particle_instance = control_node_scene.instantiate()
		particle_instance.particle_manager = self
	
	particle_instance.reset(
		start_position,
		Vector2(0, randf_range(-200, -100)),
		goal_node,
		acceleration_curve,
		air_resistance,
		clump_count
	)
	
	spawn_parent.add_child(particle_instance)
	
	return particle_instance

func spawn_control_node(start_position: Vector2, count: int = 1, spawn_duration: float = 0.0) -> void:
	if not particles_enabled:
		Global.money += count
		return

	var spawn_parent = get_node(spawn_parent_path)
	if not spawn_parent:
		push_error("Spawn parent node not found at the specified NodePath!")
		return
	
	if count <= 1 or spawn_duration <= 0.0:
		_spawn_single(start_position)
		return
	
	var num_nodes: int
	if spawn_duration >= clump_interval:
		num_nodes = int(round(spawn_duration / clump_interval))
	else:
		num_nodes = 1
	
	if count < num_nodes:
		num_nodes = count
	
	var base_particles: int = count / num_nodes
	var remainder: int = count % num_nodes
	
	var interval: float = spawn_duration / float(num_nodes)
	
	for i in range(num_nodes):
		var particles_in_node: int = base_particles
		if i < remainder:
			particles_in_node += 1
		var delay: float = i * interval
		var timer = get_tree().create_timer(delay)
		timer.timeout.connect(func() -> void:
			_spawn_single(start_position, particles_in_node)
		)
	
func return_particle(particle: Control) -> void:
	if particle.get_parent():
		particle.get_parent().remove_child(particle)
	particle_pool.append(particle)
