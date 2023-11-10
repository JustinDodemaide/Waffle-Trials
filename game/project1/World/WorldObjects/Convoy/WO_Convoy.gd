extends WorldObject

#var tile_position:Vector2 = Vector2(0,0)
var vehicles:Array[Vehicle] = []

var origin:WorldObject = null
var destination:WorldObject = null

#var moving:bool = false
var path:PackedVector2Array = []
var path_index:int = 0
var max_speed:float = 0.0

signal moved_to(tile_coord:Vector2)
signal destination_reached

func init(_vehicles:Array[Vehicle],_origin:WorldObject,_destination:WorldObject):
	vehicles = _vehicles
	origin = _origin
	tile_position = origin.tile_position
	max_speed = get_top_speed()
	new_destination(_destination)

func new_destination(new_dest:WorldObject):
	#print("new destination: ", new_dest.name)
	$MoveTimer.stop()
	destination = new_dest
	if destination.has_signal("moved_to"):
		destination.moved_to.connect("destination_moved")
	path = Global.world.astar.get_id_path(tile_position,destination.tile_position)
	#print("path: ", path)
	path_index = 0
	$MoveTimer.start(path_index)
	
func _on_move_timer_timeout():
	if path_index == path.size():
		_destination_reached()
		return
	tile_position = path[path_index]
	#$Sprite2D.position = Global.world.get_node("TileMap").map_to_local(tile_position)
	#print(name + " " + str(tile_position))
	emit_signal("moved_to",tile_position)
	path_index += 1
	var speed = max_speed
	if path_index < path.size():
		speed += Global.world.get_speed_modifier(path[path_index])
	$Sprite2D/Label.text = "speed: " + str(speed)
	$MoveTimer.start(speed)
	
func get_top_speed()->float:
	var lowest_speed = vehicles.front().speed()
	for i in vehicles:
		if i.speed() < lowest_speed:
			lowest_speed = i.speed()
	return lowest_speed

func _destination_reached()->void:
	path.clear()
	path_index = 0
	emit_signal("destination_reached")
	queue_free() # remember to delete this

func destination_moved()->void:
	new_destination(destination)

func map_sprite()->Texture2D:
	# place each of the vehicles in formation. how? idk
	return load("res://WorldMap/WorldObjects/WO_Vehicle/truck.png")

func options():
	return ["Return to origin"]

func option_chosen(option:String)->void:
	print(option)
	if option == "Return to origin":
		new_destination(origin)
	else:
		pass
