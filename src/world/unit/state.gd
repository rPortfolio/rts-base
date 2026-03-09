class_name State
extends Node


## State redirection based on StringName
## Not the safest, but the easiest
@warning_ignore("unused_signal")
signal finished(new_state: State)
var unit: Unit


func setup() -> void:
	assert(owner is Unit)
	unit = owner


func enter() -> void:
	pass


func exit() -> void:
	pass


@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass
