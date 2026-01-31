extends CharacterBody2D
class_name Player

# Exported
@export var normal_speed: float = 300.0
#@export var slow_speed: float = 150.0
@export var jump_force: float = 600.0
@export var max_jump_limit: int = 2

@export var ability_bar: ProgressBar
@export var ability_timer: Timer

@export var sprite: Rectangle

# Private
var current_speed: float

var jump_count: int = 0

var is_grounded: bool = false
var can_attack: bool = false

func _ready() -> void:
	#Events.MaskSwitched.connect(on_mask_switched)
	current_speed = normal_speed
	ability_bar.max_value = ability_timer.wait_time

func _physics_process(delta: float) -> void:
	ability_bar.value = ability_timer.time_left
	
	movement(delta)
	move_and_slide()

func movement(delta: float) -> void:
	gravity(delta)
	jump()
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and jump_count > 0:
		velocity.y = -jump_force
		jump_count -= 1
	
func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	else:
		jump_count = max_jump_limit

func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("damaged")
