extends Spatial

export(PackedScene) var bubble_template : PackedScene
export(float)       var delay           : float = 9.0

onready var timer := $Timer
onready var direct_space_state := get_world().direct_space_state

func _on_Timer_timeout():
	var inst = bubble_template.instance()
	var pos := global_transform.origin
	var result = direct_space_state.intersect_ray(
			pos + Vector3.UP * 100.0, pos, [], 4096, false, true)
	if result.size() == 0:
		inst.explode_y_position = .0
	else:
		inst.explode_y_position = result.position.y
	add_child(inst)
	inst.translation = Vector3.DOWN

func _ready():
	timer.wait_time = delay
	timer.start()
