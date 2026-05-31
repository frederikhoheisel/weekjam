@tool
extends Node3D

@onready var light: OmniLight3D = $OmniLight3D
@onready var birne: MeshInstance3D = $"Glühbirne"

@export var range: float = 5.0
@export var attenuation: float = 1.0
@export var light_color: Color = Color.WHITE
@export var emission_color: Color = Color.YELLOW
@export var energy: float = 1.0

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
