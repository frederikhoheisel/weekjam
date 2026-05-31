extends Node3D

@export var locked = false

var beer_still_here: bool = true
var open: bool = false


@onready var audio_stream_player_3_dopen: AudioStreamPlayer3D = %AudioStreamPlayer3Dopen
@onready var audio_stream_player_3_dclose: AudioStreamPlayer3D = %AudioStreamPlayer3Dclose


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") && beer_still_here:
		open = true
		$AnimationPlayer.play("OpenDoor")
		beer_still_here = false
		GameManager.fridge_reached.emit()
		body.show_sterni()
		audio_stream_player_3_dopen.play()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") && open:
		open = false
		$AnimationPlayer.play("CloseDoor")
		audio_stream_player_3_dclose.play()
