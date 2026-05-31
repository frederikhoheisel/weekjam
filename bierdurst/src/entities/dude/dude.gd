extends Node3D

@onready var head: Node3D = $Node3D/HeadPivot
@onready var left_arm: Node3D = $Node3D/LeftArmPivot
@onready var right_arm: Node3D = $Node3D/RightArmPivot
@onready var sterni: Node3D = $Node3D/RightArmPivot/sterni
@onready var animation_player = $AnimationPlayer
@onready var camera_3d: Camera3D = %Camera3D
@onready var node_3d: Node3D = $Node3D
@onready var grunt_audio_stream_player_3d: AudioStreamPlayer3D = $GruntAudioStreamPlayer3D
@onready var explosion_audio_stream_player_3d: AudioStreamPlayer3D = $ExplosionAudioStreamPlayer3D


var thirsty: bool = true
var player_here: bool = false
var look_sensitivity: float = 0.001


func _ready() -> void:
	sterni.visible = false
	interval = randf_range(interval_min, interval_max)
	GameManager.key_destroyed.connect(func(): explosion_audio_stream_player_3d.play())


var interval: float
var interval_min: float = 5.0
var interval_max: float = 15.0
var time: float = 0.0
func _physics_process(delta: float) -> void:
	time += delta
	if time >= interval:
		interval = randf_range(interval_min, interval_max)
		time = 0.0
		grunt_audio_stream_player_3d.play()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * look_sensitivity)
		#self.rotation.y = clamp(camera_3d.rotation.y, deg_to_rad(-90.0), deg_to_rad(90.0))
		camera_3d.rotate_x(-event.relative.y * look_sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-60.0), deg_to_rad(60.0))
		head.rotation.y = clamp(head.rotation.y, deg_to_rad(-60), deg_to_rad(60))


var tween: Tween
func rotate_drone() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	var dir: Vector3 = (drone.global_position - node_3d.global_position).normalized()
	var angle: float = atan2(-dir.x, -dir.z)
	tween.tween_property(node_3d, "rotation:y", node_3d.global_rotation.y + angle, 0.3)



var drone: Node3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player") && !player_here):
		drone = body
		player_here = true
		GameManager.dude_reached.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")):
		player_here = false


func hit_desk() -> void:
	animation_player.play("hit_desk")
	
func drink_beer() -> void:
	animation_player.play("drink_beer")

func type() -> void:
	animation_player.play("typing")
