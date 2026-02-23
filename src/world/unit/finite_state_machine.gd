class_name FiniteStateMachine
extends Node


@export var starting_state: String
var state: State


## A consequence of having a deferred setup instead of on_ready is that the state machine will not be active on the first frame
func setup() -> void:
	if starting_state:
		state = get_node(starting_state)
	else:
		state = get_child(0)
	enter_state(state)


func _physics_process(delta: float) -> void:
	if not state:
		return
	state.update(delta)


func set_state(new_state: State) -> void:
	exit_state(state)
	enter_state(new_state)
	state = new_state


func exit_state(old_state: State) -> void:
	old_state.exit()
	old_state.finished.disconnect(set_state)


func enter_state(new_state: State) -> void:
	new_state.finished.connect(set_state)
	new_state.enter()
