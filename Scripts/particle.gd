extends Control

var goal_node: Control = null  
var start_position: Vector2 = Vector2.ZERO
var initial_velocity: Vector2 = Vector2.ZERO
var acceleration_curve: Curve = null
var air_resistance: float = 0.0

@export var particles_ambient: GPUParticles2D
@export var particles_explode: GPUParticles2D

@export var acceleration_multiplier: float = 1.0

var velocity: Vector2 = Vector2.ZERO
var time_elapsed: float = 0.0

var explosion_triggered: bool = false
var particle_manager: Node = null
var clump_count: int = 1

func _ready() -> void:
	global_position = start_position
	velocity = initial_velocity
	particles_explode.emitting = false

func reset(new_start_position: Vector2, new_initial_velocity: Vector2, new_goal_node: Control, new_acceleration_curve: Curve, new_air_resistance: float, new_clump_count: int = 1) -> void:
	start_position = new_start_position
	initial_velocity = new_initial_velocity
	goal_node = new_goal_node
	acceleration_curve = new_acceleration_curve
	air_resistance = new_air_resistance
	
	time_elapsed = 0.0
	velocity = initial_velocity
	explosion_triggered = false
	particles_explode.emitting = false
	particles_ambient.visible = true
	global_position = start_position
	
	clump_count = new_clump_count

func _process(delta: float) -> void:
	time_elapsed += delta
	
	var acc_magnitude: float = acceleration_curve.sample(time_elapsed) if acceleration_curve else 0.0
	acc_magnitude *= acceleration_multiplier
	
	if goal_node:
		var goal_center: Vector2 = goal_node.global_position + (goal_node.size / 2)
		var direction: Vector2 = (goal_center - global_position).normalized()
		var acceleration_vector: Vector2 = direction * acc_magnitude
		
		var drag: Vector2 = -air_resistance * velocity
		
		velocity += (acceleration_vector + drag) * delta
		global_position += velocity * delta
		
		var goal_rect: Rect2 = Rect2(goal_node.global_position, goal_node.size)
		if goal_rect.has_point(global_position) and not explosion_triggered:
			particles_explode.emitting = true
			particles_ambient.visible = false
			explosion_triggered = true
			Global.money += clump_count
	
	if explosion_triggered and not particles_explode.emitting:
		if particle_manager:
			particle_manager.return_particle(self)
		else:
			queue_free()
