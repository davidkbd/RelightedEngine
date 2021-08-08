extends Spatial

onready var space_state = get_world().direct_space_state

func emit_rings(position : Vector3, count : int):
#	var distance = 2.0
#	var angle := 0
	for ring in get_tree().get_nodes_in_group("RING_CATCHED"):
		var destination : Vector3
		var destination_ok = false
		while not destination_ok:
			var angle = rand_range(-PI, PI)
			var distance = rand_range(1.0, 3.0)
			
			destination = position + Vector3(
					cos(angle) * distance, .0, sin(angle) * distance)
		
			var result = _check_floor(destination)
			if result:
				destination_ok = true
				destination = result.position

		count -= 1
		if count < 0: return
		ring.restore(position, destination)

func emit_keys(position : Vector3):
	for key in get_tree().get_nodes_in_group("KEY_CATCHED"):
		
		var destination : Vector3
		var destination_ok = false
		while not destination_ok:
			var distance = rand_range(1.0, 3.0)
			var angle = rand_range(-PI, PI)
			destination = position + Vector3(
					cos(angle) * distance, .0, sin(angle) * distance)
	
			var result = _check_floor(destination)
			if result.size():
				destination_ok = true
				destination = result.position
	
		key.restore(position, destination)

func _check_floor(position : Vector3) -> Dictionary:
	return space_state.intersect_ray(
			position + Vector3.UP,
			position + Vector3.DOWN * 20.0, [], 1024)
