extends Area

export(float) var accel := 5.0

onready var host := get_parent()

var target : Spatial
var current_speed : float

func activate(activator):
	if target \
	or activator.shield_manager.shield_type != Constants \
			.RelightedEngineShieldTypes.ELECTRIC:
		return
	current_speed = .0
	target = activator
	set_process(true)

func deactivate(activator = null):
	pass

func enable():
	set_collision_mask_bit(8, true)

func disable():
	set_collision_mask_bit(8, false)
	target = null
	set_process(false)

func _process(delta : float):
	if not target \
	or not is_instance_valid(target) \
	or target.shield_manager.shield_type != Constants.RelightedEngineShieldTypes.ELECTRIC:
		target = null
		set_process(false)
		return
	var diff : Vector3 = target.global_transform.origin - host.global_transform.origin
	var dir = diff.normalized()
	current_speed += accel * delta
	var dest = dir * current_speed
	host.global_transform.origin += dest * delta

func _ready():
	target = null
	set_process(false)
