class_name FiniteStateMachine
extends Node


var state: State


func setup(state_name: String = "") -> void:
	for child: State in get_children():
		child.setup()
	if state_name:
		state = get_node(state_name)
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
