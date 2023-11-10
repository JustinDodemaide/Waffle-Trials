extends WorldObject

var vehicle:Vehicle = null
var origin:WorldObject = null
var destination:WorldObject = null

var moving:bool = false
var speed:int = 0

func init(i_vehicle:Vehicle,i_origin:WorldObject,i_destination:WorldObject):
	vehicle = i_vehicle
	speed = vehicle.speed()
	origin = i_origin
	destination = i_destination
	move_to(destination.position)
	$Timer.start()

func move_to(target:Vector2)->void:
	$NavigationAgent2D.set_target_position(target)
	moving = true

func _on_navigation_agent_2d_target_reached():
	moving = false
	print("target reached")

func _physics_process(delta):
	if !moving:
		return
	var next_position = $NavigationAgent2D.get_next_path_position()
	move(next_position)

func move(destination):
	if !moving:
		return
	var tween = create_tween()
	tween.tween_property(self,"position",destination,speed)

func _on_timer_timeout():
	speed = vehicle.speed()
	var modifier = get_parent().get_speed_factor(position)
	if modifier > 0:
		pass
	speed += modifier
	pass
