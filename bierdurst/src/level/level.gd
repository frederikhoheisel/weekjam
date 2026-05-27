extends Node3D
class_name Level

@export var lvl_idx: int
@export var player: Node3D
@export var block_map: GridMap
@export var fridge: Node3D
@export var dude: Node3D

var player_grid_pos: Vector3
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#block_map.visible = false
	player_grid_pos = block_map.local_to_map(block_map.to_local(player.global_position))
	print("player start pos: local:", player.position, ", grid:", player_grid_pos)
	player.move_to(block_map.to_global(block_map.map_to_local(player_grid_pos)))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DOWN"):
		check_and_move(player_grid_pos + Vector3(0, 0, 1))
	if Input.is_action_just_pressed("UP"):
		check_and_move(player_grid_pos + Vector3(0, 0, -1))
	if Input.is_action_just_pressed("LEFT"):
		check_and_move(player_grid_pos + Vector3(-1, 0, 0))
	if Input.is_action_just_pressed("RIGHT"):
		check_and_move(player_grid_pos + Vector3(1, 0, 0))
	
func check_and_move(pos: Vector3) -> void:
	var cell_id: int = block_map.get_cell_item(pos)
	print("cell id:", cell_id)
	if (cell_id != 0):
		player_grid_pos = pos
		player.move_to(block_map.to_global(block_map.map_to_local(pos)))
