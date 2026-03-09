class_name UnitCollider
extends Node3D
## A square collider for fast collisions


signal collider_entered(collider: UnitCollider)
signal collider_exited(collider: UnitCollider)

const GROUP_NAME = "unit_collider"

@export var length: float = 1.0

var overlapping_colliders: Array[UnitCollider] = []


func _ready() -> void:
	add_to_group(GROUP_NAME)


func _physics_process(delta: float) -> void:
	for node: UnitCollider in get_tree().get_nodes_in_group(GROUP_NAME):
		


func overlaps(other: UnitCollider) -> bool:
	return get_rect().intersects(other.get_rect())


func get_rect() -> Rect2:
	return Rect2(
		global_position.x - length / 2,
		global_position.y - length / 2,
		length,
		length
	)
