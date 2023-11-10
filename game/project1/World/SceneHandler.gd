extends Node

signal transitioned(active_scene_name)

@onready var active_scene = $LoadingScreen

# This function calls the current active_scene's exit() function, then changes the active active_scene,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next active_scene's enter() function.
func transition_to(target_active_scene_path:String, msg: Dictionary = {}):
	if active_scene != null:
		active_scene.exit()
		active_scene.queue_free()
	active_scene = load(target_active_scene_path).instantiate()
	add_child(active_scene)
	active_scene.enter(msg)
	active_scene.scene_handler = self
	emit_signal("transitioned", active_scene.name)
	print("scene transitioned to ", active_scene.name)
