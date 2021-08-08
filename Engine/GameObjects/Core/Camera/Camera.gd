extends Spatial

var target

func player_listener_on_start_point_prepared(ring : Spatial):
	global_transform.origin = ring.global_transform.origin

func player_listener_on_prepared(new_player):
	target = new_player
	set_physics_process(true)
	get_tree().call_deferred("call_group",
			"CAMERA_LISTENER", "camera_listener_on_rotated", rotation.y - PI * .5)

func game_listener_on_title_shown():
	$StartTween.interpolate_property(
			$Camera, "size",
			1.0, 6.0, 2.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$StartTween.start()

func game_listener_on_goal_opened():
	$StartTween.interpolate_property(
			$Camera, "size",
			$Camera.size, 3.0, 10.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$StartTween.interpolate_property(
			$Camera, "rotation:y",
			$Camera.rotation.y, $Camera.rotation.y - .04, 10.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$StartTween.interpolate_property(
			self, "rotation:x",
			rotation.x, rotation.x + .3, 10.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$StartTween.interpolate_property(
			$Camera, "translation:y",
			$Camera.translation.y, $Camera.translation.y + .5, 10.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$StartTween.start()

func _physics_process(delta : float):
	var destination = target.global_transform.origin + target.velocity * 1.5
	if target.statemachine.current_state == target.statemachine.jump_state:
		_follow_jumping_target(delta)
	else:
		_follow_walking_target(delta)

func _follow_jumping_target(delta : float):
	var self_xy = Vector2(global_transform.origin.x, global_transform.origin.z)
	var tgt_xy = Vector2(target.global_transform.origin.x, target.global_transform.origin.z)
	var delta_multiplied = clamp(
			delta * self_xy.distance_squared_to(tgt_xy),
			.0,
			.12);
	global_transform.origin.x = lerp(
			global_transform.origin.x,
			target.global_transform.origin.x,
			delta_multiplied)
	global_transform.origin.z = lerp(
			global_transform.origin.z,
			target.global_transform.origin.z,
			delta_multiplied)

func _follow_walking_target(delta : float):
	var delta_multiplied = clamp(
			delta * global_transform.origin\
					.distance_squared_to(target.global_transform.origin),
			.0, .12);
	global_transform.origin = lerp(
			global_transform.origin,
			target.global_transform.origin,
			delta_multiplied)

func _ready():
	set_physics_process(false)
	get_tree().call_deferred("call_group",
			"CAMERA_LISTENER", "camera_listener_on_rotated", rotation.y - PI * .5)
