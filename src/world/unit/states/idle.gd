extends State


func update(delta: float) -> void:
	owner.move_unit(delta)
	owner.label.text = "Nearby Units: {}".format([owner.nearby_units], "{}")
