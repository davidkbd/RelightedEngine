extends Control

func game_listener_on_loaded(data : Dictionary):
	if not data.has("hud_components"): return
	_insert_components(data.hud_components, data)

func _insert_components(components : Array, data : Dictionary):
	for component in components:
		_instance(component, data)

func _instance(component, data : Dictionary):
	var inst = component.instance()
	add_child_below_node($Summary, inst)
	if inst.has_method("game_listener_on_loaded"):
		inst.game_listener_on_loaded(data)
