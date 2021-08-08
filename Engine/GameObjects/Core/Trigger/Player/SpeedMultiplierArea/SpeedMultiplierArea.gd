extends Area

onready var speed_areas  := []

onready var speed : float = _calc_multiplier()

func _on_SpeedMultiplierArea_area_entered(area):
	speed_areas.append(area)
	speed = _calc_multiplier()

func _on_SpeedMultiplierArea_area_exited(area):
	speed_areas.erase(area)
	speed = _calc_multiplier()

func _calc_multiplier() -> float:
	if speed_areas.size() < 1: return 1.0
	var r := 1.0
	for area in speed_areas:
		r *= area.get_multiplier()
	return r
