@tool
extends Node3D

@export var on: bool = true
@export var reach: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if on: turn_on()
	else: turn_off()
	$Area3D/CollisionShape3D.shape.size.z = reach * 2
	$Area3D/CollisionShape3D.position.z = reach


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Area3D/CollisionShape3D.shape.size.z = reach * 2
	$Area3D/CollisionShape3D.position.z = reach
	if on:
		$RotorPivot.rotation.z += 0.2

func turn_on() -> void:
	on = true
	$GPUParticles3D2.emitting = true
	$Area3D.monitoring = true
	
func turn_off() -> void:
	on = false
	$GPUParticles3D2.emitting = false
	$Area3D.monitoring = false
