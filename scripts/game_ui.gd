extends Control
class_name GameUI

@export var none_texture: Texture
@export var red_texture: Texture
@export var blue_texture: Texture
@export var green_texture: Texture

@export var current_active_mask_label: Label
@export var game_manager: GameManager
@export var radial_menu: RadialMenu
@export var health_bar: ProgressBar

func _ready() -> void:
	Events.health_changed.connect(_on_health_changed)
	
	radial_menu.set_items([])
	#radial_menu.add_icon_item(red_texture, "Red", 1)
	radial_menu.add_icon_item(blue_texture, "Blue", 2)
	radial_menu.add_icon_item(green_texture, "Green", 3)

func _process(_delta: float) -> void:
	current_active_mask_label.text = "Mask: %s" % Globals.Masks.keys()[Globals.current_mask].capitalize()
	
	if Input.is_action_pressed("open_radial") and Globals.can_switch:
		Engine.time_scale = 0.2
		radial_menu.open_menu(get_viewport_rect().size / 2)

func _on_health_changed(health: int) -> void:
	health_bar.value = health

func _on_radial_menu_item_selected(id: Variant, _position: Variant) -> void:
	SoundManager.switch_sfx.play()
	get_tree().call_group("switching", "switch_mask", id)
	Engine.time_scale = 1.0

func _on_radial_menu_menu_closed(_menu: Variant) -> void:
	Engine.time_scale = 1.0
