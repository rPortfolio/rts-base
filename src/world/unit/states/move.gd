extends State


@export var speed: float = 2.0
@export var idle: State


func update(delta: float) -> void:
	var direction := unit.global_position.direction_to(unit.target_position)
	var velocity := direction * speed
	unit.global_position += velocity * delta
	if unit.global_position.distance_squared_to(unit.target_position) <= unit.DISTANCE_THRESHOLD:
		finished.emit(idle)
