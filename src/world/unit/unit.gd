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
