extends TileMap

var scene_handler = null

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass
	

func _input(event):
	if event.is_action_pressed("M"):
		get_parent().transition_to("res://Level/Level.tscn")
