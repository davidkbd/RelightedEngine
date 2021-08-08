extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

func enter():
	host.rolling = false
	host.glb.run()
	host.body_colllision_area.enable()

func exit():
	host.body_colllision_area.disable()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	_calc_slope_effort(delta)
	_move(delta)
	_animate()
	
	if host.damaged:
		return statemachine.damage_state
	if Input.is_action_just_pressed("spin"):
		return statemachine.spindash_state
	if Input.is_action_just_pressed("jump"):
		return statemachine.jump_state
	if host.analog_control_length < .1:
		return statemachine.idle_state
	if host.teleport:
		return statemachine.teleport_state
	if host.impulsed:
		return statemachine.fall_state
	if host.floor_raycast_result.size() == 0:
		return statemachine.fall_state
	return self

func _calc_slope_effort(delta : float):
	if host.slope_strength > .95 and host.slope_strength < 1.05:
		host.slope_effort_i = 0.0
		host.slope_effort = lerp(host.slope_effort, 1.0, delta * 5.0)
	else:
		host.slope_effort_i = clamp(host.slope_effort_i + delta, 0.0, 1.0)
		host.slope_effort = lerp(1.0, host.slope_strength, host.slope_effort_i)
	
func _move(delta : float):
	var delta_accel = delta * (host.acceleration * host.slide_multiplier_area.slide)
	var transmitted_vel = host.linear_velocity_area.velocity
	var speed_dir_length = host.effective_speed * host.analog_control_length * host.speed_multiplier_area.speed * host.slope_effort
	host.velocity.x = lerp(host.velocity.x, host.global_transform.basis.z.x * speed_dir_length + transmitted_vel.x, delta_accel)
	host.velocity.z = lerp(host.velocity.z, host.global_transform.basis.z.z * speed_dir_length + transmitted_vel.z, delta_accel)
	host.velocity.y -= host.snap_floor * delta * speed_dir_length
	host.velocity = host.move_and_slide(host.velocity, Vector3.UP)

func _animate():
	host.glb.run_speed(
			(abs(host.velocity.x) + abs(host.velocity.z)) / 2.0)

func _turn(delta : float):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.turn_speed * host.effective_speed)
