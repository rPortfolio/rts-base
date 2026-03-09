extends State


@export var move: State


func update(_delta: float) -> void:
	if unit.global_position.distance_squared_to(unit.target_position) > unit.DISTANCE_THRESHOLD:
		finished.emit(move)
