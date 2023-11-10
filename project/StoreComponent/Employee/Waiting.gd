# Virtual base class for all states.
extends State

signal done_waiting

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	state_machine.get_node("Timer").timeout.connect(_on_timer_timeout)
	state_machine.get_node("Timer").start(_msg["wait time"])


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	state_machine.get_node("Timer").timeout.disconnect(_on_timer_timeout)


func _on_timer_timeout():
	emit_signal("done_waiting")
	
func make_outline()->void:
	pass
