extends Area

onready var ribbon_areas  := []

onready var velocity : Vector3 = _calc_transmited_velocity()

func _on_LinearVelocityArea_area_entered(area):
	ribbon_areas.append(area)
	velocity = _calc_transmited_velocity()

func _on_LinearVelocityArea_area_exited(area):
	ribbon_areas.erase(area)
	velocity = _calc_transmited_velocity()

func _calc_transmited_velocity() -> Vector3:
	if ribbon_areas.size() < 1: return Vector3.ZERO
	var r := Vector3.ZERO
	for area in ribbon_areas:
		r += area.get_velocity()
	return r
