extends CharacterBody2D
class_name Enemy

var current_damage: int = 50

@export var ellipse: Ellipse

func _ready() -> void:
	Events.MaskSwitched.connect(on_mask_switched)

func on_mask_switched(mask) -> void:
	#if Globals.current_mask != 2:
	match mask:
		0: # None
			current_damage = 50
		1: # Red
			current_damage = 10
		2: # Blue
			current_damage = 0
		3: # Green
			current_damage = 30
