extends Node
class_name GameManager

@export_file_path("*.tscn") var next_level_path: String

@export var hidden_tileset: TileMapLayer
@export var level_end: Area2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	Engine.time_scale = 1.0
	hidden_tileset.enabled = false
	level_end.body_entered.connect(_on_level_end_body_entered)
	Events.MaskSwitched.connect(on_mask_switched)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		SceneTransition.reload_scene()

func on_mask_switched(mask: Globals.Masks) -> void:
	#print(Globals.Masks.keys()[Globals.current_mask])
	match mask:
		Globals.Masks.NONE: # None
			Globals.can_damage_player = true
			
			player.aura_sprite.hide()
			player.modulate = Color("ffffffff")
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.RED: # Red
			Globals.can_damage_player = true
			
			player.aura_sprite.show()
			player.modulate = Color("ff4b4bff")
			player.can_attack = true
			hidden_tileset.enabled = false
		Globals.Masks.BLUE: # Blue
			Globals.can_damage_player = false
			
			player.aura_sprite.hide()
			player.modulate = Color("5877ffff")
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.GREEN: # Green
			Globals.can_damage_player = true
			
			player.aura_sprite.hide()
			player.modulate = Color("8cff58ff")
			hidden_tileset.enabled = true
			player.can_attack = false

func _on_level_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneTransition.change_scene(next_level_path)
