extends Node3D
class_name Level

@export var lvl_id: int
@export var moves_up: int = 20
@export var moves_left: int = 20
@export var moves_down: int = 20
@export var moves_right: int = 20

@export var player: Node3D
@export var block_map: GridMap
@export var fridge: Node3D
@export var dude: Node3D

@export var hud: HUD

@onready var move_timer: Timer = $MoveTimer
@onready var box_container: Node = %BoxContainer


var player_grid_pos: Vector3
var player_is_moving = false
var got_beer: bool = false
var box_dict: Dictionary[Box, Vector3i]
var box_pos_dict: Dictionary[Box, Vector3]
var boxes: Array

func _ready() -> void:
	#block_map.visible = false
	player_grid_pos = block_map.local_to_map(block_map.to_local(player.global_position))
	#print("player start pos: local:", player.position, ", grid:", player_grid_pos)
	player.move_to(block_map.to_global(block_map.map_to_local(player_grid_pos)))
	
	#Signal connects
	GameManager.fridge_reached.connect(_on_fridge_reached)
	GameManager.dude_reached.connect(_on_dude_reached)
	
	hud.display_moves_up(moves_up)
	hud.display_moves_left(moves_left)
	hud.display_moves_down(moves_down)
	hud.display_moves_right(moves_right)
	
	boxes = box_container.get_children()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_is_moving: return
	if Input.is_action_just_pressed("UP")  && moves_up > 0:
		check_and_move(player_grid_pos + Vector3(0, 0, -1), 2)
	if Input.is_action_just_pressed("LEFT") && moves_left > 0:
		check_and_move(player_grid_pos + Vector3(-1, 0, 0), 3)
	if Input.is_action_just_pressed("DOWN") && moves_down > 0:
		check_and_move(player_grid_pos + Vector3(0, 0, 1), 0)
	if Input.is_action_just_pressed("RIGHT") && moves_right > 0:
		check_and_move(player_grid_pos + Vector3(1, 0, 0), 1)
		
	#if (Vector3i(player_grid_pos) == block_map.local_to_map(block_map.to_local(fridge.global_position))):
	#	got_beer = true
	

func check_and_move(pos: Vector3, id: int) -> void:
	var cell_id: int = block_map.get_cell_item(pos)
	#print("cell id:", cell_id)
	player.animate(id)
	if (cell_id == 0) or check_for_box(pos): 
		player.attempt_move(block_map.to_global(block_map.map_to_local(pos)))
	else:
		player_grid_pos = pos
		player.move_to(block_map.to_global(block_map.map_to_local(pos)))
	
	
	player_is_moving = true
	move_timer.wait_time = 0.4
	move_timer.start()
	
	match id:
		2:
			moves_up -= 1
			hud.display_moves_up(moves_up)
		3:
			moves_left -= 1
			hud.display_moves_left(moves_left)
		0:
			moves_down -= 1
			hud.display_moves_down(moves_down)
		1:
			moves_right -= 1
			hud.display_moves_right(moves_right)


func check_for_box(pos: Vector3) -> bool:
	var dir: Vector3 = (player.global_position - block_map.to_global(block_map.map_to_local(pos))).normalized()
	var global_box_pos: Vector3 = block_map.to_global(block_map.map_to_local(pos))
	for box: Box in boxes:
		if global_box_pos.is_equal_approx(box.global_position):
			var cell_id: int = block_map.get_cell_item(pos - dir)
			if (cell_id == 0): return true
			
			var next_box_pos: Vector3 = global_box_pos - dir * 2.0
			for next_box: Box in boxes:
				if next_box_pos.is_equal_approx(next_box.global_position): return true
			
			box.move_to(next_box_pos)
	
	return false


func level_completed() -> void:
	# TODO: celebtration schabernack, saufi
	GameManager.load_level()
	
func _on_fridge_reached() -> void:
	print("got beer")
	got_beer = true

func _on_dude_reached() -> void:
	if (got_beer == true):
		# move to level_completed() later, the signal does nothing as of now
		GameManager.level_completed.emit()
		GameManager.load_level()


func _on_move_timer_timeout() -> void:
	player_is_moving = false
