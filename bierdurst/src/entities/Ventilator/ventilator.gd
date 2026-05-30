@tool
extends Node3D

@export var on: bool = true
@export var reach: int = 1
var current_reach: int = 1

@onready var collison_area: Area3D = $Area3D
@onready var collison_shape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var wind_particles: GPUParticles3D = $GPUParticles3D2
@onready var distance_check_ray: RayCast3D = $RayCast3D
@onready var rotor_pivot: Node3D = $RotorPivot
@onready var exit_timer: Timer = $Exit_Timer
var rotation_speed: float
var blocked_reach: float

var player_in_wind: bool = false
var player_just_exited: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_reach = reach
	collison_shape.shape.size.z = reach * 2
	collison_shape.position.z = reach
	wind_particles.lifetime = 1.2 * reach/3.0
	wind_particles.amount = 18 * reach
	rotation_speed = 0.05 * reach
	distance_check_ray.target_position.z = reach * 2.0
	if on: turn_on()
	else: turn_off()
	
	# signals
	GameManager.drone_moved.connect(_on_drone_moved)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint() && on:
		if on: turn_on()
		else: turn_off()
		collison_shape.shape.size.z = current_reach * 2
		collison_shape.position.z = current_reach
		wind_particles.lifetime = clamp(1.2 * current_reach/3.0, 0.1, 60.)
		wind_particles.amount = clamp(16 * reach, 1.0, 256)
		rotation_speed = 0.05 * reach
		distance_check_ray.target_position.z = reach * 2.0
	
	rotor_pivot.rotation.z += rotation_speed

func _physics_process(_delta: float) -> void:
	if on: check_obstacles()


func turn_on() -> void:
	on = true
	wind_particles.emitting = true
	collison_area.monitoring = true
	rotation_speed = 0.05 * reach

func turn_off() -> void:
	on = false
	wind_particles.emitting = false
	collison_area.monitoring = false
	rotation_speed = 0.0

func check_obstacles() -> void:
	distance_check_ray.force_raycast_update()
	var collider: Node3D = distance_check_ray.get_collider()
	if collider != null && collider.is_in_group("wind_obstacle"):
		var dist: float = to_local(distance_check_ray.get_collision_point()).length()
		var new_reach: int = dist / 2
		update_reach(int(new_reach))
	if collider == null:
		update_reach(reach)

func update_reach(new_reach) -> void:
	current_reach = clamp(new_reach, 0, reach)
	collison_shape.shape.size.z = current_reach * 2.0
	collison_shape.position.z = current_reach
	wind_particles.lifetime = clamp(1.2 * current_reach/3.0, 0.01, 60.0)
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_wind =  true
		if player_just_exited: 
			print("player reentered, but just exited, false trigger")
			return
		print("player entered")
		print("player detected, reach: ", reach)
		var block_distance: int = current_reach - (self.to_local(body.global_position).z) / 2
		var direction: Vector3 = self.to_global(Vector3(0., 0., 1.0)) - self.global_position
		print("blow_dist", block_distance)
		GameManager.blow_drone.emit(direction, block_distance)
		
func _on_drone_moved(dir: Vector3) -> void:
	if player_in_wind:
		for body in collison_area.get_overlapping_bodies():
			if body.is_in_group("player") && player_in_wind:
				print("player moved, still in area, reach: ", reach)
				var block_distance: int = current_reach - (self.to_local(body.global_position).z / 2) + 1
				var direction: Vector3 = self.to_global(Vector3(0., 0., 1.0)) - self.global_position
				if dir.dot(direction) == 0: 
					print("moved out of stream")
					return
				if  dir.dot(direction) > 0:
					print("player moved with stream")
					return
				print("blow_dist", current_reach - self.to_local(body.global_position).z / 2)
				GameManager.blow_drone.emit(direction, block_distance)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player exited")
		exit_timer.start()
		player_just_exited = true
		player_in_wind = false
		


func _on_exit_timer_timeout() -> void:
	player_just_exited = false
