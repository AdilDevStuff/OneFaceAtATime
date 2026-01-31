extends Node
class_name SwitchingComponent

enum Masks {
	NONE,
	RED,
	GREEN,
	BLUE,
}

@export var current_mask: Masks = Masks.NONE

var mask_index: int = 0

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_red"):
		switch_mask(Masks.RED)
		print("Red Mask Activated")
	elif Input.is_action_just_pressed("switch_blue"):
		switch_mask(Masks.BLUE)
		print("Blue Mask Activated")
	elif Input.is_action_just_pressed("switch_green"):
		switch_mask(Masks.GREEN)
		print("Green Mask Activated")

func switch_mask(selected_mask: Masks) -> void:
	current_mask = selected_mask
