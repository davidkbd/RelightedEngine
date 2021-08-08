tool
extends HBoxContainer

class_name ValueIndicator

export(float) var value : float = .0      setget set_value, get_value
export(float) var min_value : float = .0  setget set_min_value, get_min_value
export(float) var max_value : float = 1.0 setget set_max_value, get_max_value

func set_value(new_value : float):
	value = new_value
	_update_view()

func get_value() -> float: return value

func set_min_value(new_value : float):
	min_value = new_value
	_update_view()

func get_min_value() -> float: return min_value

func set_max_value(new_value : float):
	max_value = new_value
	_update_view()

func get_max_value() -> float: return max_value

func _update_view():
	var texture_on = load("res://Engine/MainScenes/StartMenu/Textures/ValueUnitOn.png")
	var texture_off = load("res://Engine/MainScenes/StartMenu/Textures/ValueUnitOff.png")
	var limit = max_value - min_value
	var calc = round(((value - min_value) / limit) * 10.0) * .1
	var i : float = .0
	for vu in get_children():
		if i > 0:
			vu.texture = texture_on if i <= calc else texture_off
		i += .1
