extends Control
class_name GameUI

@export var current_active_mask_label: Label
@export var game_manager: GameManager

func _process(_delta: float) -> void:
	current_active_mask_label.text = "Mask: %s" % Globals.Masks.keys()[Globals.current_mask]
