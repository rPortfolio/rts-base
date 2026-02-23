class_name State
extends Node


## State redirection based on StringName
## Not the safest, but the easiest
@warning_ignore("unused_signal")
signal finished(new_state: State)


func enter() -> void:
	pass


func exit() -> void:
	pass


@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass


func get_state_data() -> Dictionary:
	return {}


@warning_ignore("unused_parameter")
func load_state_data(state_data: Dictionary) -> void:
	pass
