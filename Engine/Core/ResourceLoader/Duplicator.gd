extends Node

export(int) var find_sublevels_limit := 10
export(NodePath) var target : NodePath

func duplicate_object(object : Node):
	var inst = object.duplicate(true)
	_instance_instanciable_members(object, inst)
	_clean_nodes(inst, 0)
	get_node(target).add_child(inst)
	# Se podria mejorar si posicionamos cada cosa en una posicion
	inst.translation = Vector3.ZERO

func _instance_instanciable_members(original_object : Node, duplicated_object : Node):
	for prop in original_object.get_property_list():
		if prop.hint_string == "PackedScene":
			duplicated_object.add_child(original_object.get(prop.name).instance())

func _clean_nodes(inst : Node, sublevels : int):
	for child in inst.get_children():
		if child is AudioStreamPlayer or child is AudioStreamPlayer2D or child is AudioStreamPlayer3D:
			child.free()
			continue
		if child is Particles or child is CPUParticles:
			child.emitting = true
		if sublevels < find_sublevels_limit:
			_clean_nodes(child, sublevels + 1)
