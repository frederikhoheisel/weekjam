extends Node3D


var drone: CharacterBody3D


var blink_time: float = 0.8
var blink_timer: float
var mode: int = 0
var security_camera: Camera3D
var radio: Node3D
var crosshair: CanvasLayer


@onready var fpv_camera: Camera3D = %FPVCamera
@onready var texture_rect: TextureRect = $SubViewport/TextureRect
@onready var sprite: Sprite3D = $Sprite3D
@onready var viewport: SubViewport = $SubViewport
@onready var settings: CanvasLayer = $SubViewport/Settings


func _ready() -> void:
	GameManager.game_over.connect(func(): $Sprite3D.hide())
	security_camera = get_tree().get_first_node_in_group("SecCam")
	security_camera.call_deferred("reparent", $SubViewport)
	
	drone = get_tree().get_first_node_in_group("player")
	radio = get_tree().get_first_node_in_group("radio")
	crosshair = get_tree().get_first_node_in_group("Crosshair")


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
	
	if event.is_action_pressed("open_settings"):
		settings.visible = not settings.visible
		crosshair.visible = settings.visible


func _input(event: InputEvent) -> void:
	if event is not InputEventMouse:
		return
	
	var vp_pos: Vector2 = _project_to_viewport(event.position)
	if vp_pos == Vector2.INF:
		return
	var relayed: InputEventMouse = event.duplicate() as InputEventMouse
	relayed.position = vp_pos
	
	viewport.push_input(relayed, true)


func _project_to_viewport(screen_pos: Vector2) -> Vector2:
	var cam: Camera3D = get_viewport().get_camera_3d()
	
	var ray_origin: Vector3 = cam.project_ray_origin(screen_pos)
	var ray_dir: Vector3 = cam.project_ray_normal(screen_pos)
	
	var plane_normal: Vector3 = sprite.global_transform.basis.z.normalized()
	var plane_point: Vector3 = sprite.global_position
	
	var denom: float = plane_normal.dot(ray_dir)
	if abs(denom) < 0.001:
		return Vector2.INF
	var t: float = plane_normal.dot(plane_point - ray_origin) / denom
	if t <= 0.0:
		return Vector2.INF
	
	var hit_local: Vector3 = sprite.global_transform.affine_inverse() * (ray_origin + ray_dir * t)
	
	var vp_size: Vector2 = viewport.size
	var pixel_pos: Vector2 = Vector2(
			hit_local.x / sprite.pixel_size + vp_size.x * 0.5,
			-hit_local.y / sprite.pixel_size + vp_size.y * 0.5
		)
	
	if pixel_pos.x < 0.0 or pixel_pos.x > vp_size.x or \
		pixel_pos.y < 0.0 or pixel_pos.y > vp_size.y:
			return Vector2.INF
	
	return pixel_pos


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value * 0.03)


func _on_radio_slider_value_changed(value: float) -> void:
	radio.set_volume(value * 0.03)


func _on_station_button_pressed() -> void:
	radio.play_next()


func _on_return_button_pressed() -> void:
	settings.hide()
	crosshair.visible = settings.visible
