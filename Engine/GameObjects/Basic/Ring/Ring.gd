extends Area

export(bool) var snap_to_floor_on_ready := true

onready var restore_tween := $RestoreTween
onready var destroy_timer := $DestroyTimer
onready var timeout_timer := $TimeoutTimer
onready var magnetic_follow_area := $MagneticFollowArea

onready var catched := false

const RAY_SNAP_START_POSITION := Vector3.UP * 1.0
const RAY_SNAP_END_POSITION := Vector3.DOWN * 2.0
const CATCHED_POSITION = Vector3.DOWN * 10.0

func activate(activator):
	if catched: return
	if activator is Player:
		_catch()

func deactivate(activator):
	pass

func restore(position : Vector3, position2 : Vector3):
	remove_from_group("RING_CATCHED")
	magnetic_follow_area.enable()
	global_transform.origin.y = position.y
	restore_tween.resume_all()
	restore_tween.interpolate_property(self, "global_transform:origin:x",
			position.x, position2.x, .25, Tween.TRANS_SINE, Tween.EASE_OUT)
	restore_tween.interpolate_property(self, "global_transform:origin:z",
			position.z, position2.z, .25, Tween.TRANS_SINE, Tween.EASE_OUT)
	restore_tween.interpolate_method(self, "_snap_to_floor",
			.0, .0, .25)
	restore_tween.repeat = false
	restore_tween.start()
	destroy_timer.start()

func mark_catched():
	global_transform.origin = CATCHED_POSITION
	add_to_group("RING_CATCHED")
	catched = true

func _catch():
	VfxEmitter.ring(global_transform.origin)
	magnetic_follow_area.disable()
	mark_catched()
	restore_tween.stop_all()
	get_tree().call_group("PLAYER_LISTENER", "player_listener_on_ring_catched")
	destroy_timer.stop()
	timeout_timer.stop()

func _on_RestoreTween_tween_all_completed():
	catched = false

func _on_DestroyTimer_timeout():
	restore_tween.interpolate_property(self, "visible",
			false, true, .1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	restore_tween.repeat = true
	restore_tween.start()
	timeout_timer.start()

func _snap_to_floor(not_used_param_1 = null, not_used_param_2 = null):
	var state = get_world().direct_space_state
	var ray_result = state.intersect_ray(
			global_transform.origin + RAY_SNAP_START_POSITION,
			global_transform.origin + RAY_SNAP_END_POSITION,
			[], 1024
			)
	if ray_result.size():
		global_transform.origin = ray_result.position

func _on_TimeoutTimer_timeout():
	queue_free()

func _ready():
	if snap_to_floor_on_ready:
		call_deferred("_snap_to_floor")
