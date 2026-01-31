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

func on_mask_switched(mask: Globals.Masks) -> void:
	#print(Globals.Masks.keys()[Globals.current_mask])
	match mask:
		Globals.Masks.NONE: # None
			player.modulate = Color.WHITE
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.RED: # Red
			player.modulate = Color.RED
			player.can_attack = true
			hidden_tileset.enabled = false
		Globals.Masks.BLUE: # Blue
			player.modulate = Color.BLUE
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.GREEN: # Green
			player.modulate = Color.GREEN
			hidden_tileset.enabled = true
			player.can_attack = false
