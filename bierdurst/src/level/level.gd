extends Node3D
class_name Level

@export var lvl_id: int
@export var moves_up: int
@export var moves_left: int
@export var moves_down: int
@export var moves_right: int

@export var player: Node3D
@export var block_map: GridMap
@export var fridge: Node3D
@export var dude: Node3D

var player_grid_pos: Vector3
var got_beer: bool = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#block_map.visible = false
	player_grid_pos = block_map.local_to_map(block_map.to_local(player.global_position))
	#print("player start pos: local:", player.position, ", grid:", player_grid_pos)
	player.move_to(block_map.to_global(block_map.map_to_local(player_grid_pos)))
	
	#Signal connects
	GameManager.fridge_reached.connect(_on_fridge_reached)
	GameManager.dude_reached.connect(_on_dude_reached)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DOWN") && moves_down > 0:
		moves_down -= 1
		check_and_move(player_grid_pos + Vector3(0, 0, 1))
	if Input.is_action_just_pressed("UP")  && moves_up > 0:
		moves_up -= 1
		check_and_move(player_grid_pos + Vector3(0, 0, -1))
	if Input.is_action_just_pressed("LEFT") && moves_left > 0:
		moves_left -= 1
		check_and_move(player_grid_pos + Vector3(-1, 0, 0))
	if Input.is_action_just_pressed("RIGHT") && moves_right > 0:
		moves_right -= 1
		check_and_move(player_grid_pos + Vector3(1, 0, 0))
		
	#if (Vector3i(player_grid_pos) == block_map.local_to_map(block_map.to_local(fridge.global_position))):
	#	got_beer = true
	
func check_and_move(pos: Vector3) -> void:
	var cell_id: int = block_map.get_cell_item(pos)
	#print("cell id:", cell_id)
	if (cell_id != 0):
		player_grid_pos = pos
		player.move_to(block_map.to_global(block_map.map_to_local(pos)))
		
func level_completed() -> void:
	# TODO: celebtration schabernack, saufi
	GameManager.load_level()
	
func _on_fridge_reached() -> void:
	print("got beer")
	got_beer = true

func _on_dude_reached() -> void:
	if (got_beer == true):
		GameManager.level_completed.emit()
		GameManager.load_level()
