# Virtual base class for all states.
extends State

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var next_position = state_machine.navigation_agent.get_next_path_position()
	move(next_position)

var previous_destination
func move(destination):
	#print("moving to: ", destination)
	var character_body = get_parent().get_parent()
	if destination.x < character_body.position.x:
		state_machine.get_parent().get_node("AnimatedSprite2D").flip_h = true
	else:
		state_machine.get_parent().get_node("AnimatedSprite2D").flip_h = false
	character_body.velocity = (destination - character_body.position).normalized() * character_body.speed
	#$AnimatedSprite2D.play("move")
	character_body.move_and_slide()


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	state_machine.get_parent().get_node("AnimatedSprite2D").play("move")


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	state_machine.get_parent().get_node("AnimatedSprite2D").play("idle")
