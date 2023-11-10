extends Node
class_name WorldObject

# this script exists as a workaround to a WO_Convoy 'tile_map' indentifier
# issue as demonstrated in https://github.com/godotengine/godot/issues/78146

var tile_position:Vector2 = Vector2(0,0)

func map_sprite()->Texture2D:
	return preload("res://icon.svg")

func options():
	return []
	
func option_chosen(_option:String)->void:
	pass
