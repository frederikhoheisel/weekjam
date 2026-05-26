extends Node3D
class_name Level

@export var lvl_idx: int
@export var player: CharacterBody3D
@export var grid_map: GridMap

var player_grid_pos: Vector3
var grid: Array[bool] = []
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	player_grid_pos = grid_map.local_to_map(grid_map.to_local(player.global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("DOWN"):
		if check_tile(player_grid_pos + Vector3(0, 0, 1)):
			player_grid_pos += Vector3(0, 0, 1)
	
func check_tile(pos: Vector3):
	var cell = grid_map.get_cell_item(pos)
