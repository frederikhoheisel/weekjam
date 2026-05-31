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
	birne.mesh.surface_get_material(0).emission_color = emission_color
	
func _process(delta: float) -> void:
		if Engine.is_editor_hint():
				light.omni_range = range
				light.omni_attenuation = attenuation
				light.light_color = light_color
				light.light_energy = energy
				birne.surface_get_material(0).emission_color = emission_color
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			flicker_light()
			schedule_next_flicker(light)


func flicker_light():
	var tween = get_tree().create_tween()
	var original_energy = energy
	
	# Type of flicker (weighted probabilities)
	var flicker_type = randf()
	
	if flicker_type < 0.6:  # 60% chance: quick double flicker
		tween.tween_property(light, "light_energy", 0.0, 0.03)
		tween.tween_property(light, "light_energy", 0.0, 0.08)
		tween.tween_property(light, "light_energy", original_energy, 0.03)
		tween.tween_property(light, "light_energy", original_energy, 0.15)
		tween.tween_property(light, "light_energy", 0.0, 0.03)
		tween.tween_property(light, "light_energy", 0.0, 0.05)
		tween.tween_property(light, "light_energy", original_energy, 0.03)
		
	elif flicker_type < 0.85:  # 25% chance: struggling to turn on
		for i in range(randi_range(3, 6)):
			tween.tween_property(light, "light_energy", 0.0, 0.04)
			tween.tween_property(light, "light_energy", 0.0, randf_range(0.08, 0.2))
			tween.tween_property(light, "light_energy", original_energy * randf_range(0.3, 0.8), 0.04)
			tween.tween_property(light, "light_energy", original_energy * randf_range(0.3, 0.8), 0.05)
		tween.tween_property(light, "light_energy", original_energy, 0.05)
		
	else:  # 15% chance: single quick blink
		tween.tween_property(light, "light_energy", 0.0, 0.02)
		tween.tween_property(light, "light_energy", 0.0, 0.06)
		tween.tween_property(light, "light_energy", original_energy, 0.02)

func schedule_next_flicker(light: Light3D):
	flicker_timer = randf_range(min_flicker_time, max_flicker_time)
