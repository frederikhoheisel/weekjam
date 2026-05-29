@tool
extends Node3D

@export var on: bool = true
@export var reach: int = 1

@onready var collison_area: Area3D = $Area3D
@onready var collison_shape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var wind_particles: GPUParticles3D = $GPUParticles3D2
@onready var distance_check_ray: RayCast3D = $RayCast3D
@onready var rotor_pivot: Node3D = $RotorPivot

var rotation_speed: float
var blocked_reach: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collison_shape.shape.size.z = reach * 2
	collison_shape.position.z = reach
	wind_particles.lifetime = 1.2 * reach/3.0
	wind_particles.amount = 18 * reach
	rotation_speed = 0.05 * reach
	distance_check_ray.target_position.z = reach * 2.0
	if on: turn_on()
	else: turn_off()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if on: turn_on()
		else: turn_off()
		collison_shape.shape.size.z = reach * 2
		collison_shape.position.z = reach
		wind_particles.lifetime = 1.2 * reach/3.0
		wind_particles.amount = 16 * reach
		rotation_speed = 0.05 * reach
		
	if on:
		rotor_pivot.rotation.z += rotation_speed

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		distance_check_ray.force_raycast_update()
		var collider: Node3D = distance_check_ray.get_collider()
		if collider != null && collider.is_in_group("wind_obstacle"):
			var new_reach = (distance_check_ray.get_collision_point() - global_position).length()/2.0
			update_reach(int(new_reach))


func turn_on() -> void:
	on = true
	wind_particles.emitting = true
	collison_area.monitoring = true

func turn_off() -> void:
	on = false
	wind_particles.emitting = false
	collison_area.monitoring = false

func update_reach(new_reach) -> void:
	reach = new_reach
	collison_shape.shape.size.z = reach * 2
	collison_shape.position.z = reach
	wind_particles.lifetime = 1.2 * reach/3.0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pass
		#body.blow()
