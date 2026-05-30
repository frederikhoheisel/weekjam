@tool
extends HBoxContainer
class_name UIKey


@export var texture: Texture2D:
	set(v):
		texture = v
		if not is_node_ready(): return
		texture_rect.call_deferred("set_texture", texture)


var tween: Tween


@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	if texture:
		texture_rect.texture = texture


func display(n: int) -> void:
	label.text = str(n)# + 'x'
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	texture_rect.self_modulate = Color(1.0, 0.0, 0.0)
	tween.tween_property(texture_rect, "self_modulate", Color(1.0, 1.0, 1.0), 0.1)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	texture_rect.custom_minimum_size = Vector2(128.0, 128.0)
	tween.tween_property(texture_rect, "custom_minimum_size", Vector2(96.0, 96.0), 0.1)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	label.label_settings.font_size = 64
	tween.tween_property(label.label_settings, "font_size", 48, 0.1)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	if n <= 0:
		GameManager.key_destroyed.emit()
		texture = preload("res://assets/textures/kaputt.png")
		label.hide()
		animated_sprite_2d.show()
		animated_sprite_2d.play("explode")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.hide()
