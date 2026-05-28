extends Node3D

@export var locked = false

var beer_still_here: bool = true
var open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") && beer_still_here:
		open = true
		$AnimationPlayer.play("OpenDoor")
		beer_still_here = false
		GameManager.fridge_reached.emit()
		body.show_sterni()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") && open:
		open = false
		$AnimationPlayer.play("CloseDoor")
