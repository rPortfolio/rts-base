extends State


const BUILD_FRAMES_KEY = "build_frames" ## Key stored as constant to avoid typos
const FPS = 60

@export var build_time_seconds: float = 1
@export var idle: State

@onready var build_time_frames: int = int(build_time_seconds * FPS)


func setup() -> void:
	super.setup()
	if BUILD_FRAMES_KEY not in unit.data:
		unit.data[BUILD_FRAMES_KEY] = 0


func exit() -> void:
	unit.sprite.modulate = Color.WHITE


func update(_delta: float) -> void:
	unit.data[BUILD_FRAMES_KEY] = unit.data[BUILD_FRAMES_KEY] + 1
	unit.sprite.modulate = Color(0.5, 0.5, 1, float(unit.data[BUILD_FRAMES_KEY]) / build_time_frames)
	if unit.data[BUILD_FRAMES_KEY] == build_time_frames:
		finished.emit(idle)
