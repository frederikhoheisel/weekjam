@tool
extends Node3D


@export_tool_button("explode", "Callable") var explode_action = explode


@onready var boom: GPUParticles3D = %Boom
@onready var smoke: GPUParticles3D = %Smoke
@onready var debris: GPUParticles3D = %Debris


func _ready() -> void:
	GameManager.key_destroyed.connect(explode)


func explode() -> void:
	boom.restart()
	smoke.restart()
	debris.restart()
