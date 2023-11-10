extends Node

@onready var astar = AStarGrid2D.new()
@onready var player_location:WorldObject = $WO_Test

signal world_object_added(object:WorldObject)

@onready var world_clock = $WorldClock
var time:int = 0

func _ready():
	Global.world = self
	Global.emit_signal("world_ready")
	initialize_astar()
	#print(astar.get_point_path(Vector2(2,1),Vector2(7,1)))
	#for i in astar.get_point_path(Vector2(1,14),Vector2(29,3)):
	#	var sprite = Sprite2D.new()
	#	sprite.position = i
	#	sprite.texture = load("res://dot.png")
	#	add_child(sprite)
	var vehicles:Array[Vehicle] = [load("res://Vehicles/Vehicle.gd").new()]
	$WO_Test.tile_position = Vector2(1,14)
	$WO_Test2.tile_position = Vector2(29,3)
	$WO_Test.launch_convoy(vehicles,$WO_Test2)
	#$Timer.start(2)
	$SceneHandler.transition_to("res://Level/Level.tscn")

func add_world_object(object:WorldObject):
	add_child(object)
	emit_signal("world_object_added",object)

func initialize_astar():
	astar.size = Vector2i(255,255)
	astar.cell_size = Vector2(16, 16)
	#astar.set_jumping_enabled(true)
	astar.update()
	for coord in $TileMap.get_used_cells(0):
		var cell_data = $TileMap.get_cell_tile_data(0, coord)
		var speed_modifier = cell_data.get_custom_data("speed_modifier")
		# if the tile is an impass, astar.set_point_solid(coord)
		astar.set_point_weight_scale(coord, speed_modifier)

func get_speed_modifier(tile_coord:Vector2)->float:
	var cell_data = $TileMap.get_cell_tile_data(0, tile_coord)
	return cell_data.get_custom_data("speed_modifier")

func _input(event):
	# debug inputs
	if event.is_action_pressed("F1"):
		print("global: ", $TileMap.get_global_mouse_position(), ", tile: ", $TileMap.local_to_map($TileMap.get_global_mouse_position()))

func _on_timer_timeout():
	var vehicles:Array[Vehicle] = [load("res://Vehicles/Vehicle.gd").new()]
	$WO_Test.launch_convoy(vehicles,$WO_Test2)


func _on_world_clock_timeout():
	time += 1
	


func _on_music_finished():
	$Music.play()


func _on_mute_pressed():
	if $CanvasLayer/Mute.button_pressed:
		$Music.play()
		$CanvasLayer/Mute.icon = load("res://volume_up_FILL0_wght400_GRAD0_opsz24.png")
	else:
		$Music.stop()
		$CanvasLayer/Mute.icon = load("res://volume_off_FILL0_wght400_GRAD0_opsz24.png")
