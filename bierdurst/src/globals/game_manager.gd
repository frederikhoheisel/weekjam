extends Node

# Signals
signal level_started(level_id: int)
signal level_completed(level_id: int)
signal game_over

signal fridge_reached
signal dude_reached

var current_level: Node = null
var current_level_id: int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reload_level() -> void:
	get_tree().reload_current_scene()

func load_level() -> void:
	if (is_instance_valid(current_level)):
		current_level.queue_free()
	current_level_id += 1
	var level: Resource = load(str("res://src/level/level_", current_level_id, ".tscn"))
	current_level = level.instantiate()
	self.add_child.call_deferred(current_level)
	#get_tree().current_scene = current_level
	level_started.emit(current_level_id)
