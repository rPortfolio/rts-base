class_name Unit
extends Node3D

## An example unit script
## Originally created without physics in mind
## CharacterBody3Ds are usually better choices for moving nodes than Node3Ds


const SPEED = 2

var nearby_units: int = 0
var target_position: Vector3

@onready var sprite: Sprite3D = %Sprite3D
@onready var label: Label3D = %Label3D
@onready var fsm: FiniteStateMachine = %FiniteStateMachine


func _ready() -> void:
	fsm.setup.call_deferred()


func move_unit(delta) -> void:
	var velocity := Vector3.ZERO
	var direction := global_position.direction_to(target_position)
	velocity = direction * SPEED
	## Soft collision
	for collider: Area3D in %Collision.get_overlapping_areas():
		velocity += collider.global_position.direction_to(%Collision.global_position) * SPEED
	global_position += velocity * delta


func get_saved_unit() -> SavedUnit:
	var saved_unit := SavedUnit.new()
	saved_unit.position = position
	saved_unit.target_position = target_position
	saved_unit.state_name = fsm.state.name
	saved_unit.state_data = fsm.state.get_state_data()
	return saved_unit


func _on_effect_radius_area_entered(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units += 1


func _on_effect_radius_area_exited(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units -= 1
