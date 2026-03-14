class_name Unit
extends Node3D

## Unit Script
## Designed to be loosely coupled with the state system

const DISTANCE_THRESHOLD = 0.3 ## In meters
const GROUND_DETECT_OFFSET = 100 ## Meters above/below position

@export var fsm: FiniteStateMachine
@export var sprite: Sprite3D
@export var selection_indicator: Sprite3D

## A dictionary of values that need to persist on save
## Initial values are added by the states themselves
var data: Dictionary
var target_position: Vector3


func _physics_process(_delta: float) -> void:
	snap_to_ground()


func setup(g_pos: Vector3, t_pos: Vector3, s_data := {}, state_name := "") -> void:
	global_position = g_pos
	target_position = t_pos
	data = s_data
	fsm.setup(state_name)
	force_update_transform() ## Make position update immediately


func snap_to_ground() -> void:
	var space_state := get_world_3d().direct_space_state
	
	var cast_start := global_position
	cast_start.y += GROUND_DETECT_OFFSET ## Ray must start above unit for unit to snap upwards
	var cast_end := global_position
	cast_end.y -= GROUND_DETECT_OFFSET ## Ray must end below unit for unit to snap downwards
	
	var query := PhysicsRayQueryParameters3D.create(cast_start, cast_end)
	var result := space_state.intersect_ray(query)
	
	if result:
		position.y = result.position.y


func select() -> void:
	selection_indicator.show()


func unselect() -> void:
	selection_indicator.hide()
