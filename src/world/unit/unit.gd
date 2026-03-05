class_name Unit
extends Node3D

## An example unit script
## Originally created without physics in mind
## CharacterBody3Ds are usually better choices for moving nodes than Node3Ds


const SPEED = 2
const DIST_THRESHOLD = 1

var nearby_units: int = 0
var target_position: Vector3

@onready var sprite: Sprite3D = %Sprite3D
@onready var label: Label3D = %Label3D
@onready var fsm: FiniteStateMachine = %FiniteStateMachine
@onready var ground_detector: RayCast3D = %GroundDetector ## MUST BE ABOVE PLAYER'S GLOBAL POSITION
@onready var collision: Area3D = %Collision
@onready var effect_radius: Area3D = %EffectRadius


func _ready() -> void:
	fsm.setup.call_deferred()


func move_unit(delta: float) -> void:
	var velocity := Vector3.ZERO
	var direction := global_position.direction_to(target_position)
	if global_position.distance_squared_to(target_position) > DIST_THRESHOLD:
		velocity = direction * SPEED
	global_position += velocity * delta
	soft_collide(delta)


func soft_collide(delta: float) -> void:
	## Push away from other units
	for collider: Area3D in collision.get_overlapping_areas():
		## Push after all other units have calculated their pushes
		var push_force := collider.global_position.direction_to(collision.global_position) * SPEED / 2
		(func() : global_position += push_force * delta).call_deferred()
	## Push out of ground
	if ground_detector.is_colliding():
		global_position.y = ground_detector.get_collision_point().y
func get_saved_unit() -> SavedUnit:
	var saved_unit := SavedUnit.new()
	saved_unit.position = position
	saved_unit.target_position = target_position
	saved_unit.state_name = fsm.state.name
	saved_unit.state_data = fsm.state.get_state_data()
	return saved_unit


func select() -> void:
	%SelectionIndicator.show()


func unselect() -> void:
	%SelectionIndicator.hide()


func _on_effect_radius_area_entered(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units += 1


func _on_effect_radius_area_exited(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units -= 1
