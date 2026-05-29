extends Node3D


@export var drone: CharacterBody3D


var blink_time: float = 0.8
var blink_timer: float


@onready var camera_3d: Camera3D = %Camera3D
@onready var texture_rect: TextureRect = $SubViewport/TextureRect


func _physics_process(delta: float) -> void:
	camera_3d.global_position = drone.global_position + Vector3(0.0, 0.5, -0.5)
	blink_timer += delta
	if blink_timer > blink_time:
		blink_timer = 0.0
		texture_rect.visible = not texture_rect.visible
