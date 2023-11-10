extends Node
class_name WorldMap

var scene_handler = null

var hovered_object:WorldMapObject = null
var options_menu = null

func enter(_msg := {}) -> void:
	var world = Global.world
	world.get_node("TileMap").visible = true
	var objects:Array[WorldObject] = []
	for i in world.get_children():
		if i is WorldObject:
			objects.append(i)
			
	for i in objects:
		make_map_object(i)
	
	world.world_object_added.connect(make_map_object)
	#make_map_object()

func exit() -> void:
	Global.world.get_node("TileMap").visible = false

func make_map_object(world_object:WorldObject):
	var map_object = preload("res://WorldMap/WorldObjects/WO_Generic/WO_WorldObject.tscn").instantiate()
	map_object.init(world_object)
	add_child(map_object)

func _process(_delta):
	$State.text = $StateMachine.state.name

func object_hovered(object:WorldMapObject)->void:
	hovered_object = object
	$HoveredObjectLabel.text = object.name

func object_selected(object:WorldMapObject):
	$StateMachine.transition_to("Option", {"worldmap object" = object})

func _input(event):
	if event.is_action_pressed("Space"):
		if hovered_object == null:
			return
		$Camera2D.move_camera_to(hovered_object.position)
		await $Camera2D.done_moving
		print("camera arrived")
		object_selected(hovered_object)
	#if event.is_action_pressed("1"):
		#$Truck.move_to(get_global_mouse_position())
		#print("mouse position: ", get_global_mouse_position())
	#if event.is_action_pressed("LeftClick"):
	#	print("WorldMap")
	#	$StateMachine.transition_to("Observation")
		#add_child(preload("res://WorldMap/WM_MouseClick/WM_MouseClick.tscn").instantiate())
		#print("pressed")
	if event.is_action_pressed("Esc") or event.is_action_pressed("M"):
		Global.world.get_node("SceneHandler").transition_to("res://Level/Level.tscn")
