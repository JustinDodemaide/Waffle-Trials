# Virtual base class for all states.
extends State

var options_menu:WM_OptionsMenu = null
var map_object:WorldMapObject = null

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


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg = {}):
	map_object = _msg["worldmap object"]
	options_menu = load("res://WorldMap/WM_OptionsMenu/WM_OptionsMenu.tscn").instantiate()
	options_menu.option_state = self
	options_menu.init(map_object)
	map_object.add_child(options_menu)

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	if options_menu == null:
		return
	options_menu.queue_free()
	options_menu = null

func option_chosen(option:String):
	options_menu.queue_free()
	map_object.object.option_chosen(option)
