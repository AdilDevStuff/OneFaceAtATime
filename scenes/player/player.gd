extends CharacterBody2D
class_name Player

# Exported
@export_group("Properties")
@export var normal_speed: float = 300.0
@export var jump_force: float = 600.0
@export var max_jump_limit: int = 2

@export_group("Knockback")
@export var knockback_force: float = 450.0
@export var knockback_up_force: float = 300.0
@export var knockback_control_lock_time: float = 0.15
@export_group("Health")
@export var max_health: int = 100

var knockback_dir: int = 0
var control_locked := false

var current_health: int = 0

@export_group("References")
@export var sprite: Rectangle
@export var ability_timer: Timer
@export var aura_sprite: Ellipse
@export var ability_bar: ProgressBar
@export var anim_player: AnimationPlayer
@export var death_particles: GPUParticles2D
@export var switch_particles: GPUParticles2D

# Private
var current_speed: float

var jump_count: int = 0
var direction: float = 0

var is_grounded: bool = false
var can_attack: bool = false

func _ready() -> void:
	Events.killed.connect(_on_killed)
	Events.damaged.connect(_on_damaged)
	
	current_health = max_health
	Events.health_changed.emit(current_health)
	
	current_speed = normal_speed
	ability_bar.max_value = ability_timer.wait_time

func _physics_process(delta: float) -> void:
	ability_bar.value = ability_timer.time_left
	
	movement(delta)
	move_and_slide()

func movement(delta: float) -> void:
	gravity(delta)
	
	if Input.is_action_just_pressed("jump") or MobileInput.jump_pressed:
		jump()
		MobileInput.jump_pressed = false
	
	if control_locked:
		return
	
	direction = Input.get_axis("left", "right")
	if direction and current_health > 0:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func jump() -> void:
	if jump_count > 0:
		SoundManager.jump_sfx.play()
		velocity.y = -jump_force
		var tween := create_tween()
		tween.tween_property(sprite, "rotation_degrees", snapped(sprite.rotation_degrees + 90.0 * direction, 90.0), 0.15)
		await tween.finished
		sprite.rotation_degrees = 0

		jump_count -= 1

func new_tween(object: Object, nodepath: NodePath, final_value: Variant, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(object, nodepath, final_value, duration)

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
		Events.health_changed.emit(current_health)
		anim_player.play("flash")
		if current_health <= 0:
			Events.killed.emit()

func _on_killed() -> void:
	if get_tree().current_scene != null:
		anim_player.play("death")
		await anim_player.animation_finished
		SceneTransition.reload_scene()

func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if Globals.can_damage_player:
			SoundManager.hurt_sfx.play()
			apply_knockback(body.global_position)
			Events.damaged.emit(body.current_damage)
	if body.is_in_group("lava"):
		if Globals.can_damage_player:
			SoundManager.death_sfx.play()
			apply_knockback(body.global_position)
			Events.damaged.emit(100)
	if body.is_in_group("spikes"):
		if Globals.can_damage_player:
			SoundManager.hurt_sfx.play()
			apply_knockback(body.global_position)
			Events.damaged.emit(25)
