extends Node
class_name GameManager

@export_file("*.tscn") var next_level_path: String

@export var blue_color: Color = Color("5877ffff")
@export var green_color: Color = Color("8cff58ff")
@export var red_color: Color = Color("ff4b4bff") 

@export var hidden_tileset: TileMapLayer
@export var level_end: Area2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	Engine.time_scale = 1.0
	get_tree().call_group("switching", "switch_mask", Globals.Masks.NONE)
	Globals.can_switch = true
	hidden_tileset.enabled = false
	Globals.can_damage_player = true

	Events.mask_switched.connect(on_mask_switched)
	level_end.body_entered.connect(_on_level_end_body_entered)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		SceneTransition.reload_scene()

func on_mask_switched(mask: Globals.Masks) -> void:
	match mask:
		Globals.Masks.NONE: # None
			Globals.can_damage_player = true
			player.collision_mask = 30
			
			player.aura_sprite.hide()
			Globals.new_tween(player, "modulate", Color.WHITE, 0.2)
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.RED: # Red
			player.collision_mask = 30
			Globals.can_damage_player = true
			
			player.aura_sprite.show()
			Globals.new_tween(player, "modulate", red_color, 0.2)
			player.can_attack = true
			hidden_tileset.enabled = false
		Globals.Masks.GHOST: # Blue
			player.collision_mask = 4
			Globals.can_damage_player = false
			
			player.aura_sprite.hide()
			Globals.new_tween(player, "modulate", blue_color, 0.2)
			player.can_attack = false
			hidden_tileset.enabled = false
		Globals.Masks.EAGLE: # Green
			player.collision_mask = 30
			Globals.can_damage_player = true
			
			player.aura_sprite.hide()
			Globals.new_tween(player, "modulate", green_color, 0.2)
			hidden_tileset.enabled = true
			player.can_attack = false

func _on_level_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Globals.new_tween(player, "scale", Vector2.ONE * 0.001, 0.2)
		SoundManager.level_complete_sfx.play()
		SceneTransition.change_scene(next_level_path)
