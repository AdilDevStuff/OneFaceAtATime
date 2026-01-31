extends CharacterBody2D
class_name Player

# Exported
@export_group("Properties")
@export var normal_speed: float = 300.0
#@export var slow_speed: float = 150.0
@export var jump_force: float = 600.0
@export var max_jump_limit: int = 2

@export_group("Knockback")
@export var knockback_force: float = 450.0
@export var knockback_up_force: float = 300.0
@export var knockback_control_lock_time: float = 0.15

var knockback_dir: int = 0
var control_locked := false

@export var max_health: int = 100
var current_health: int = 0

@export var ability_bar: ProgressBar
@export var ability_timer: Timer

@export var sprite: Rectangle
@export var aura_sprite: Ellipse

# Private
var current_speed: float

var jump_count: int = 0

var is_grounded: bool = false
var can_attack: bool = false

func _ready() -> void:
	Events.Damaged.connect(_on_damaged)
	Events.Killed.connect(_on_killed)
	
	current_health = max_health
	current_speed = normal_speed
	ability_bar.max_value = ability_timer.wait_time

func _physics_process(delta: float) -> void:
	ability_bar.value = ability_timer.time_left
	
	if current_health <= 0:
		Events.Killed.emit()
	
	movement(delta)
	move_and_slide()

func movement(delta: float) -> void:
	gravity(delta)
	jump()
	
	if control_locked:
		return
	
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

func apply_knockback(from_position: Vector2) -> void:
	knockback_dir = sign(global_position.x - from_position.x)
	if knockback_dir == 0:
		knockback_dir = -sign(velocity.x) if velocity.x != 0 else -1

	velocity.x = knockback_dir * (knockback_force + abs(velocity.x) * 0.4)
	
	velocity.y = -knockback_up_force
	
	jump_count = max_jump_limit - 1
	
	control_locked = true
	get_tree().create_timer(knockback_control_lock_time).timeout.connect(
		func(): control_locked = false
	)

func _on_damaged(damage: int) -> void:
	if Globals.can_damage_player:
		current_health -= damage
		$AnimationPlayer.play("flash")

func _on_killed() -> void:
	SceneTransition.reload_scene()

func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if Globals.can_damage_player:
			apply_knockback(body.global_position)
			Events.Damaged.emit(body.current_damage)
	if body.is_in_group("lava"):
		if Globals.can_damage_player:
			apply_knockback(body.global_position)
			Events.Damaged.emit(25)
	if body.is_in_group("spikes"):
		if Globals.can_damage_player:
			apply_knockback(body.global_position)
			Events.Damaged.emit(25)
