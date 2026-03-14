extends State


@export var speed: float = 2.0
@export var idle: State


func update(delta: float) -> void:
	var target_position_flat := unit.target_position
	target_position_flat.y = 0
	var global_position_flat := unit.global_position
	global_position_flat.y = 0
	
	var direction := global_position_flat.direction_to(target_position_flat)
	var velocity := direction * speed
	unit.global_position += velocity * delta
	
	if global_position_flat.distance_squared_to(target_position_flat) <= unit.DISTANCE_THRESHOLD:
		finished.emit(idle)
