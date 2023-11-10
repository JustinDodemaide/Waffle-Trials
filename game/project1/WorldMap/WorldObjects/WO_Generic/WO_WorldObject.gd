extends Area2D
class_name WorldMapObject

var object:WorldObject = null

func init(obj:WorldObject):
	object = obj
	position = Global.world.get_node("TileMap").map_to_local(object.tile_position)
	$Sprite2D.texture = object.map_sprite()
	if object.has_signal("moved_to"):
		object.moved_to.connect(object_moved)
		
func object_moved(_object):
	position = Global.world.get_node("TileMap").map_to_local(object.tile_position)

func _on_mouse_entered():
	#print("mouse is hovering over ", name)
	get_parent().object_hovered(self)
	#$CollisionShape2D.modulate = Color.RED
func _on_mouse_exited():
	pass
	#print("mouse is no longer hovering over ", name)
	#$CollisionShape2D.modulate = Color.WHITE
