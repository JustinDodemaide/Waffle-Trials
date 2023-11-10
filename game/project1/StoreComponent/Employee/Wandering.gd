# Virtual base class for all states.
extends State

# Reference to the state machine, to call its `transition_to()` method directly.
# That's one unorthodox detail of our state implementation, as it adds a dependency between the
# state and the state machine objects, but we found it to be most efficient for our needs.
# The state machine node will set it.


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent):
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta):
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta):
	pass

var wander_center:Vector2
func _on_timer_timeout():
	# try to find a task to do
	var level = state_machine.get_parent().get_parent().get_parent() # one of the worst lines of code ive written
	var ticket = level.get_ticket(state_machine.get_parent().supertask)
	if ticket != null:
		print("accepting ticket")
		state_machine.get_parent().add_task(ticket)
		if !state_machine.get_parent().tasks.is_empty():
			return
	
	# if there arent any tasks, choose wander location
	var nav_agent = state_machine.navigation_agent
	var safety:int = 0
	var center:Vector2 = state_machine.get_parent().position
	#print("center: ", center)
	while true:
		# all of this is to solve a repathing loop problem
		randomize()
		var x = randi_range(64,128)
		var y = randi_range(64,128)
		x *= randi_range(-1,1)
		y *= randi_range(-1,1)
		if (x < 32) && (x > -32):
			continue
		if (y < 32) && (y > -32):
			continue
		var wander_position:Vector2 = center + Vector2(x,y)
		if (wander_position.x < 0) or (wander_position.y < 0):
			continue
		#if (wander_position.x - center.x < 64) or (wander_position.y - center.y < 64):
		#	continue
		nav_agent.set_target_position(wander_position)
		if level.is_reachable(wander_position):
			# print("wander position: ", wander_position)
			break
		safety += 1
		if safety >= 10:
			nav_agent.set_target_position(state_machine.get_parent().position)
	state_machine.get_node("Timer").start(randf_range(1,5))
	state_machine.transition_to("Moving")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg = {}):
	state_machine.get_node("Timer").timeout.connect(_on_timer_timeout)
	state_machine.get_node("Timer").start(randf_range(1,5))

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	state_machine.get_node("Timer").timeout.disconnect(_on_timer_timeout)
