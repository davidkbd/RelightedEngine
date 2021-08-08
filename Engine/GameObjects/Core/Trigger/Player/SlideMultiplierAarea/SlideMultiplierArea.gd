extends Area

onready var host := get_parent()
onready var slide_areas  := []

onready var slide : float = _calc_multiplier()

func _on_SpeedMultiplierArea_area_entered(area):
	slide_areas.append(area)
	slide = _calc_multiplier()

func _on_SpeedMultiplierArea_area_exited(area):
	slide_areas.erase(area)
	slide = _calc_multiplier()

func _calc_multiplier() -> float:
	if slide_areas.size() < 1: return 1.0
	var r := 1.0
	for area in slide_areas:
		if host.shield_manager.shield_type != Constants.RelightedEngineShieldTypes.ICE\
		and area.get_slide_material() == Constants.RelightedEngineSlideMaterial.ICE:
			r *= area.get_multiplier()
	return r
