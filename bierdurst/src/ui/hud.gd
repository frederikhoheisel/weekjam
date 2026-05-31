extends CanvasLayer
class_name HUD


var tween: Tween


@onready var ui_key_w: UIKey = %UIKeyW
@onready var ui_key_a: UIKey = %UIKeyA
@onready var ui_key_s: UIKey = %UIKeyS
@onready var ui_key_d: UIKey = %UIKeyD
@onready var reset: TextureRect = $Reset
@onready var key_audio_stream_player: AudioStreamPlayer = $KeyAudioStreamPlayer


func _ready() -> void:
	ui_key_a.label.label_settings = ui_key_w.label.label_settings.duplicate()
	ui_key_s.label.label_settings = ui_key_w.label.label_settings.duplicate()
	ui_key_d.label.label_settings = ui_key_w.label.label_settings.duplicate()


func reset_press() -> void:
	key_audio_stream_player.play()
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	reset.self_modulate = Color(1.0, 0.0, 0.0)
	tween.tween_property(reset, "self_modulate", Color(1.0, 1.0, 1.0), 0.1)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	reset.custom_minimum_size = Vector2(96.0, 96.0)
	tween.tween_property(reset, "custom_minimum_size", Vector2(64.0, 64.0), 0.1)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	await tween.finished
	GameManager.current_level_id -= 1
	GameManager.load_level()


func display_moves_up(amount: int) -> void:
	key_audio_stream_player.play()
	ui_key_w.display(amount)


func display_moves_left(amount: int) -> void:
	key_audio_stream_player.play()
	ui_key_a.display(amount)


func display_moves_down(amount: int) -> void:
	key_audio_stream_player.play()
	ui_key_s.display(amount)


func display_moves_right(amount: int) -> void:
	key_audio_stream_player.play()
	ui_key_d.display(amount)
