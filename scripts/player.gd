extends CharacterBody2D

# Exported
@export var speed: float = 300.0
@export var jump_force: float = 600.0
@export var max_jump_limit: int = 2

# Private
var jump_count: int = 0

var is_grounded: bool = false

func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()

func movement(delta: float) -> void:
	gravity(delta)
	jump()
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and jump_count > 0:
		velocity.y = -jump_force
		jump_count -= 1
	
func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	else:
		jump_count = max_jump_limit
