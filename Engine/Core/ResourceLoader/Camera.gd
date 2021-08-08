extends Camera

func _physics_process(delta : float):
	translation.z += delta * get_parent().speed

func _ready():
	call_deferred("make_current")
