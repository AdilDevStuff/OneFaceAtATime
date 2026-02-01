extends Control
class_name MainMenu

@export var colors: Array[Color]
@export var buttons: VBoxContainer

var color_index := 0

@onready var face_label: Label = $Label2

func _ready() -> void:
	for btn in buttons.get_children():
		btn.pivot_offset_ratio = Vector2(0.5, 0.5)

func change_color_smooth():
	if colors.is_empty():
		return

	color_index = (color_index + 1) % colors.size()
	var next_color := colors[color_index]

	var tween := create_tween()
	tween.tween_property(
		face_label.label_settings,
		"font_color",
		next_color,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_play_pressed() -> void:
	SceneTransition.change_scene("uid://bntjng2xj52wc")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_face_text_timer_timeout() -> void:
	change_color_smooth()
