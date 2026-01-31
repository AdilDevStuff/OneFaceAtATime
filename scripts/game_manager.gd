extends Node
class_name GameManager

@export var hidden_tileset: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	hidden_tileset.enabled = false
	Events.MaskSwitched.connect(on_mask_switched)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func on_mask_switched(mask) -> void:
	match mask:
		0: # None
			# Normal Enemy Follow Speed
			Globals.can_enemy_chase = true
			player.can_attack = false
			hidden_tileset.enabled = false
		1: # Red
			# Fast Enemy Follow Speed
			player.can_attack = true
			Globals.can_enemy_chase = true
			hidden_tileset.enabled = false
		2: # Blue
			# No Enemy Follow
			player.can_attack = false
			hidden_tileset.enabled = false
			Globals.can_enemy_chase = false
		3: # Green
			# Slow Enemy Follow Speed
			hidden_tileset.enabled = true
			
			player.can_attack = false
			Globals.can_enemy_chase = false
