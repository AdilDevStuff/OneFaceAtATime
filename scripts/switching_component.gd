extends Node
class_name SwitchingComponent

@export var ability_timer: Timer
@export var ability_bar: ProgressBar
@export var cooldown_timer: Timer

var can_switch: bool = true

@export var cooldown_info: Label

func _input(_event: InputEvent) -> void:
	if can_switch:
		if Input.is_action_just_pressed("switch_none"):
			switch_mask(Globals.Masks.NONE)
			#print("No Mask Activated")
		elif Input.is_action_just_pressed("switch_red"):
			switch_mask(Globals.Masks.RED)
			#print("Red Mask Activated")
		elif Input.is_action_just_pressed("switch_blue"):
			switch_mask(Globals.Masks.BLUE)
			#print("Blue Mask Activated")
		elif Input.is_action_just_pressed("switch_green"):
			switch_mask(Globals.Masks.GREEN)
			#print("Green Mask Activated")

func _process(_delta: float) -> void:
	cooldown_info.text = "Cooldown %.2f" % cooldown_timer.time_left 

func switch_mask(selected_mask: Globals.Masks) -> void:
	ability_bar.show()

	if selected_mask != Globals.Masks.NONE: 
		ability_timer.start(5.0)
	else:
		ability_timer.stop()
		ability_bar.hide()

	Globals.current_mask = selected_mask
	Events.MaskSwitched.emit(selected_mask)

func _on_ability_timer_timeout() -> void:
	cooldown_info.show()

	can_switch = false
	ability_bar.hide()
	ability_timer.stop()
	switch_mask(Globals.Masks.NONE)
	Globals.current_mask = Globals.Masks.NONE
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	cooldown_info.hide()
	can_switch = true
