extends Area

func get_multiplier() -> float:
	return get_parent().multiplier

func get_slide_material() -> int:
	return get_parent().slide_material
