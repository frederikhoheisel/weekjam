@tool
extends Node3D

@onready var light: OmniLight3D = $OmniLight3D
@onready var birne: MeshInstance3D = $"Glühbirne"

@export var range: float = 5.0
@export var attenuation: float = 1.0
@export var light_color: Color = Color.WHITE
@export var emission_color: Color = Color.YELLOW
@export var energy: float = 1.0

@export var min_flicker_time: float = 15.0
@export var max_flicker_time: float = 90.0

var flicker_timer: float = 15.0

func _ready() -> void:
	light.omni_range = range
	light.omni_attenuation = attenuation
	light.light_color = light_color
	light.light_energy = energy
	birne.get_active_material(0).emission = emission_color
	
func _process(delta: float) -> void:
		if Engine.is_editor_hint():
				light.omni_range = range
				light.omni_attenuation = attenuation
				light.light_color = light_color
				light.light_energy = energy
				birne.get_active_material(0).emission = emission_color
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			flicker_light()
			schedule_next_flicker()


func flicker_light():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)  # allows both tracks to run simultaneously
	var original_energy = energy
	var mat = birne.get_active_material(0) as StandardMaterial3D

	# Helper: tween both light and emission together
	# We'll build two parallel tracks manually by calling set_parallel
	# Instead, use a method that sets both at once:
	
	tween.set_parallel(false)  # sequential steps
	
	var flicker_type = randf()

	if flicker_type < 0.6:  # 60%: quick double flicker
		_flicker_step(tween, mat, 0.0, 0.03)
		_flicker_step(tween, mat, 0.0, 0.08)
		_flicker_step(tween, mat, original_energy, 0.03)
		_flicker_step(tween, mat, original_energy, 0.15)
		_flicker_step(tween, mat, 0.0, 0.03)
		_flicker_step(tween, mat, 0.0, 0.05)
		_flicker_step(tween, mat, original_energy, 0.03)

	elif flicker_type < 0.85:  # 25%: struggling to turn on
		for i in range(randi_range(3, 6)):
			_flicker_step(tween, mat, 0.0, 0.04)
			_flicker_step(tween, mat, 0.0, randf_range(0.08, 0.2))
			_flicker_step(tween, mat, original_energy * randf_range(0.3, 0.8), 0.04)
			_flicker_step(tween, mat, original_energy * randf_range(0.3, 0.8), 0.05)
		_flicker_step(tween, mat, original_energy, 0.05)

	else:  # 15%: single quick blink
		_flicker_step(tween, mat, 0.0, 0.02)
		_flicker_step(tween, mat, 0.0, 0.06)
		_flicker_step(tween, mat, original_energy, 0.02)


func _flicker_step(tween: Tween, mat: StandardMaterial3D, target_energy: float, duration: float) -> void:
	tween.tween_property(light, "light_energy", target_energy, duration)
	tween.tween_property(mat, "emission_energy_multiplier", target_energy, duration)

func schedule_next_flicker():
	flicker_timer = randf_range(min_flicker_time, max_flicker_time)
