extends Node
class_name SwitchingComponent

@export var ability_timer: Timer
@export var ability_bar: ProgressBar
@export var cooldown_timer: Timer


@export var cooldown_info: Label
@export var animation_player: AnimationPlayer
@export var switch_particles: GPUParticles2D

func _input(_event: InputEvent) -> void:
	if Globals.can_switch:
		if Input.is_action_just_pressed("switch_none"):
			switch_mask(Globals.Masks.NONE)
		elif Input.is_action_just_pressed("switch_red"):
			switch_mask(Globals.Masks.RED)
		elif Input.is_action_just_pressed("switch_blue"):
			switch_mask(Globals.Masks.GHOST)
		elif Input.is_action_just_pressed("switch_green"):
			switch_mask(Globals.Masks.EAGLE)

func _process(_delta: float) -> void:
	cooldown_info.text = "Cooldown %.2f" % cooldown_timer.time_left 

func switch_mask(selected_mask: Globals.Masks) -> void:
	if selected_mask == Globals.current_mask:
		return

	ability_bar.show()
	animation_player.play("switch")
	switch_particles.restart()
	
	if selected_mask != Globals.Masks.NONE: 
		ability_timer.start(5.0)
	else:
		ability_timer.stop()
		ability_bar.hide()

	Globals.current_mask = selected_mask
	Events.mask_switched.emit(selected_mask)

func _on_ability_timer_timeout() -> void:
	cooldown_info.show()
	SoundManager.cooldown_sfx.play()

	Globals.can_switch = false
	ability_bar.hide()
	ability_timer.stop()
	switch_mask(Globals.Masks.NONE)
	Globals.current_mask = Globals.Masks.NONE
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	cooldown_info.hide()
	Globals.can_switch = true
