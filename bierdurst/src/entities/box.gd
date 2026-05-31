extends StaticBody3D
class_name Box


@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func move_to(pos: Vector3) -> void:
	var tween =  get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, 0.3).set_trans(Tween.TRANS_SINE).set_delay(0.1)
	gpu_particles_3d.emitting = true
	tween.tween_callback(func(): gpu_particles_3d.emitting = false)
	audio_stream_player_3d.play()
