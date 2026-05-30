extends Node3D

var thirsty: bool = true
var player_here: bool = false
var look_sensitivity: float = 0.001


@onready var camera_3d: Camera3D = %Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * look_sensitivity)
		#self.rotation.y = clamp(camera_3d.rotation.y, deg_to_rad(-90.0), deg_to_rad(90.0))
		camera_3d.rotate_x(-event.relative.y * look_sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-60.0), deg_to_rad(60.0))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player") && !player_here):
		player_here = true
		GameManager.dude_reached.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")):
		player_here = false
