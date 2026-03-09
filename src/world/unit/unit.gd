class_name Unit
extends Node3D

## Unit Script
## Designed to be loosely coupled with the state system

const DISTANCE_THRESHOLD = 1 ## In meters

@export var fsm: FiniteStateMachine
@export var sprite: Sprite3D
@export var selection_indicator: Sprite3D

## A dictionary of values that need to persist on save
## Initial values are added by the states themselves
var data: Dictionary
var target_position: Vector3


func setup(g_pos: Vector3, t_pos: Vector3, s_data := {}, state_name := "") -> void:
	global_position = g_pos
	target_position = t_pos
	data = s_data
	fsm.setup(state_name)
	force_update_transform() ## Make position update immediately


func select() -> void:
	selection_indicator.show()


func unselect() -> void:
	selection_indicator.hide()


#const SPEED = 2
#const DIST_THRESHOLD = 1
#
#var nearby_units: int = 0
#var target_position: Vector3
#
#@onready var sprite: Sprite3D = %Sprite3D
#@onready var label: Label3D = %Label3D
#@onready var fsm: FiniteStateMachine = %FiniteStateMachine
#@onready var ground_detector: RayCast3D = %GroundDetector ## MUST BE ABOVE PLAYER'S GLOBAL POSITION
#@onready var collision: Area3D = %Collision
#@onready var effect_radius: Area3D = %EffectRadius
#
#
#func _ready() -> void:
	#fsm.setup.call_deferred()
#
#
#func move_unit(delta: float) -> void:
	#var velocity := Vector3.ZERO
	#var direction := global_position.direction_to(target_position)
	#if global_position.distance_squared_to(target_position) > DIST_THRESHOLD:
		#velocity = direction * SPEED
	#global_position += velocity * delta
	#soft_collide.call_deferred(delta)
#
#
#func soft_collide(delta: float) -> void:
	### Push away from other units
	#var push_force: Vector3 = Vector3.ZERO
	#for collider: Area3D in collision.get_overlapping_areas():
		### Push after all other units have calculated their pushes
		#push_force += collider.global_position.direction_to(collision.global_position) * SPEED / 2
	#(func() : global_position += push_force * delta).call_deferred()
	### Push out of ground
	#if ground_detector.is_colliding():
		#global_position.y = ground_detector.get_collision_point().y
#func get_saved_unit() -> SavedUnit:
	#var saved_unit := SavedUnit.new()
	#saved_unit.position = position
	#saved_unit.target_position = target_position
	#saved_unit.state_name = fsm.state.name
	#saved_unit.state_data = fsm.state.get_state_data()
	#return saved_unit
#
#
#func select() -> void:
	#%SelectionIndicator.show()
#
#
#func unselect() -> void:
	#%SelectionIndicator.hide()
#
#
#func _on_effect_radius_area_entered(area: Area3D) -> void:
	#if not is_ancestor_of(area):
		#nearby_units += 1
#
#
#func _on_effect_radius_area_exited(area: Area3D) -> void:
	#if not is_ancestor_of(area):
		#nearby_units -= 1
