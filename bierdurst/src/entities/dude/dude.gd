extends Node3D

var thirsty: bool = true
var player_here: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player") && !player_here):
		player_here = true
		GameManager.dude_reached.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")):
		player_here = false
