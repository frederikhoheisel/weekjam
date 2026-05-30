extends Node3D


@export var drone: CharacterBody3D


var blink_time: float = 0.8
var blink_timer: float
var mode: int = 0
var security_camera: Camera3D


@onready var fpv_camera: Camera3D = %FPVCamera
@onready var texture_rect: TextureRect = $SubViewport/TextureRect


func _ready() -> void:
	GameManager.game_over.connect(func(): $Sprite3D.hide())
	security_camera = get_tree().get_first_node_in_group("SecCam")
	security_camera.call_deferred("reparent", $SubViewport)


func _physics_process(delta: float) -> void:
	fpv_camera.global_position = drone.global_position + Vector3(0.0, 0.5, -0.5)
	blink_timer += delta
	if blink_timer > blink_time:
		blink_timer = 0.0
		texture_rect.visible = not texture_rect.visible


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_camera"):
		mode = 0 if mode == 1 else 1
	if event.is_action_pressed("fpv_cam"):
		mode = 0
	if event.is_action_pressed("sec_cam"):
		mode = 1
	
	match mode:
		0:
			security_camera.clear_current()
			fpv_camera.make_current()
		1:
			fpv_camera.clear_current()
			security_camera.make_current()
