extends StaticBody3D
class_name Box


@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


func move_to(pos: Vector3) -> void:
	var tween =  get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, 0.4).set_trans(Tween.TRANS_SINE).set_delay(0.1)
