extends Node3D


@export var wiggle_amount: float = PI / 16.0
@export var wiggle_time: float = 0.2


@onready var drone_thruster_south: Node3D = %DroneThrusterSouth
@onready var drone_thruster_north: Node3D = %DroneThrusterNorth
@onready var drone_thruster_east: Node3D = %DroneThrusterEast
@onready var drone_thruster_west: Node3D = %DroneThrusterWest


var wiggle_tween: Tween


func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_up"):
		animate(0)
	if Input.is_action_just_released("ui_left"):
		animate(1)
	if Input.is_action_just_released("ui_down"):
		animate(2)
	if Input.is_action_just_released("ui_right"):
		animate(3)


func animate(id: int) -> void:
	if wiggle_tween:
		wiggle_tween.kill()
	wiggle_tween = create_tween()
	wiggle_tween.set_parallel(false)
	
	match id:
		0:
			drone_thruster_north.toggle()
			wiggle_tween.tween_property(self, "rotation", Vector3(wiggle_amount, 0.0, 0.0), wiggle_time)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			wiggle_tween.tween_callback(drone_thruster_north.turn_off)
		1:
			drone_thruster_west.toggle()
			wiggle_tween.tween_property(self, "rotation", Vector3(0.0, 0.0, -wiggle_amount), wiggle_time)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			wiggle_tween.tween_callback(drone_thruster_west.turn_off)
		2:
			drone_thruster_south.toggle()
			wiggle_tween.tween_property(self, "rotation", Vector3(-wiggle_amount, 0.0, 0.0), wiggle_time)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			wiggle_tween.tween_callback(drone_thruster_south.turn_off)
		3:
			drone_thruster_east.toggle()
			wiggle_tween.tween_property(self, "rotation", Vector3(0.0, 0.0, wiggle_amount), wiggle_time)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			wiggle_tween.tween_callback(drone_thruster_east.turn_off)
	
	wiggle_tween.tween_property(self, "rotation", Vector3(0.0, 0.0, 0.0), wiggle_time)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
