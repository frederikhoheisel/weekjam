extends CanvasLayer
class_name HUD


@onready var ui_key_w: UIKey = %UIKeyW
@onready var ui_key_a: UIKey = %UIKeyA
@onready var ui_key_s: UIKey = %UIKeyS
@onready var ui_key_d: UIKey = %UIKeyD


func _ready() -> void:
	ui_key_a.label.label_settings = ui_key_w.label.label_settings.duplicate()
	ui_key_s.label.label_settings = ui_key_w.label.label_settings.duplicate()
	ui_key_d.label.label_settings = ui_key_w.label.label_settings.duplicate()


func display_moves_up(amount: int) -> void:
	ui_key_w.display(amount)


func display_moves_left(amount: int) -> void:
	ui_key_a.display(amount)


func display_moves_down(amount: int) -> void:
	ui_key_s.display(amount)


func display_moves_right(amount: int) -> void:
	ui_key_d.display(amount)
