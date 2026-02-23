extends State


@export var timer: Timer
@export var idle: State


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func enter() -> void:
	print("Building...")
	%Collision.monitorable = false
	%EffectRadius.monitoring = false
	timer.start()


func exit() -> void:
	print("Finished Building")
	%Collision.monitorable = true
	%EffectRadius.monitoring = true
	owner.sprite.modulate = Color.WHITE


func update(_delta: float) -> void:
	owner.label.text = "Building...\n{}s Left".format([int(timer.time_left) + 1], "{}")
	owner.sprite.modulate = Color(0.5, 0.5, 1, 1 - timer.time_left / timer.wait_time)


func get_state_data() -> Dictionary:
	return {
		"time_left" : timer.time_left,
	}


func load_state_data(state_data: Dictionary) -> void:
	timer.wait_time = state_data["time_left"]


func _on_timer_timeout() -> void:
	finished.emit(idle)
