class_name Unit
extends Node3D

## An example unit script
## Originally created without physics in mind
## CharacterBody3Ds are usually better choices for moving nodes than Node3Ds


const SPEED = 2

var is_waiting: bool = true
var nearby_units: int = 0
var target_position: Vector3


func _ready() -> void:
	target_position = global_position


func _physics_process(delta: float) -> void:
	if is_waiting:
		%Label3D.text = "Building...\n{}s Left".format([int(%WaitTimer.time_left) + 1], "{}")
		%Sprite3D.modulate = Color(0.5, 0.5, 1, 1 - %WaitTimer.time_left / %WaitTimer.wait_time)
	else:
		%Label3D.text = "Nearby Units: {}".format([nearby_units], "{}")
		move_unit(delta)


func move_unit(delta) -> void:
	var velocity := Vector3.ZERO
	var direction := global_position.direction_to(target_position)
	velocity = direction * SPEED
	## Soft collision
	for collider: Area3D in %Collision.get_overlapping_areas():
		velocity += collider.global_position.direction_to(%Collision.global_position) * SPEED
	global_position += velocity * delta


func _on_timer_timeout() -> void:
	is_waiting = false
	%Collision.monitorable = true
	%EffectRadius.monitoring = true
	%Sprite3D.modulate = Color.WHITE


func _on_effect_radius_area_entered(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units += 1


func _on_effect_radius_area_exited(area: Area3D) -> void:
	if not is_ancestor_of(area):
		nearby_units -= 1
