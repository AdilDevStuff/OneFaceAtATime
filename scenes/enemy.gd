extends CharacterBody2D
class_name Enemy

@export var normal_move_speed: float = 200.0
@export var fast_move_speed: float = 300.0
@export var slow_move_speed: float = 100.0
@export var max_health: int = 100

var current_health: int
var current_speed: float

var is_in_range: bool = false

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	Events.MaskSwitched.connect(on_mask_switched)
	
	current_health = max_health
	current_speed = slow_move_speed

func _physics_process(_delta: float) -> void:
	handle_gravity()

	if is_in_range and Globals.can_enemy_chase: # if Red Mask is active 
		follow_player() # Follow Player
	else:
		velocity.x = 0

	move_and_slide()

func follow_player() -> void:
	var direction = global_position.direction_to(player.global_position).normalized()
	velocity = Vector2(direction.x * current_speed, velocity.y)

func handle_gravity() -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y

func on_mask_switched(mask) -> void:
	match mask:
		0: # None
			current_speed = slow_move_speed
		1: # Red
			current_speed = fast_move_speed
		2: # Green
			current_speed = slow_move_speed
		3: # Blue
			current_speed = 0

func _on_follow_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = true

func _on_follow_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
