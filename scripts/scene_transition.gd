extends CanvasLayer

@onready var trans_anim: AnimationPlayer = $SceneTransAnim

func change_scene(target: String) -> void:
	trans_anim.play("fade")
	await trans_anim.animation_finished
	get_tree().change_scene_to_file(target)
	trans_anim.play_backwards("fade")

func reload_scene() -> void:
	trans_anim.play("fade")
	await trans_anim.animation_finished
	get_tree().reload_current_scene()
	trans_anim.play_backwards("fade")

# ---------- SIGNALS ---------- #
