extends CharacterBody2D
class_name Enemy

var current_damage: int = 50

@export var ellipse: Ellipse

func _ready() -> void:
	Events.MaskSwitched.connect(on_mask_switched)

func on_mask_switched(mask) -> void:
	match mask:
		0: # None
			ellipse.hide()
			current_damage = 50
		1: # Red
			ellipse.show()
			current_damage = 10
		2: # Blue
			ellipse.hide()
			current_damage = 0
		3: # Green
			ellipse.hide()
			current_damage = 30
