extends WorldObject

#var tile_position:Vector2 = Vector2(0,0)

func map_sprite()->Texture2D:
	return preload("res://icon.svg")
	
func launch_convoy(vehicles:Array[Vehicle],destination:WorldObject)->void:
	#print("launching convoy")
	var convoy = preload("res://World/WorldObjects/Convoy/WO_Convoy.tscn").instantiate()
	Global.world.add_world_object(convoy)
	convoy.init(vehicles,self,destination)
