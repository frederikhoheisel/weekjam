extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func move_to(pos: Vector3) -> void:
	#print("move player to", pos)
	var tween =  get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, 0.5)
