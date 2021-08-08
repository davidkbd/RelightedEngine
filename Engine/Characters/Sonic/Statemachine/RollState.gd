extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

func enter():
	host.glb.spin()
	host.rolling = true
	host.body_colllision_area.enable()

func exit():
	host.body_colllision_area.disable()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta, Vector2(host.velocity.x, host.velocity.z))
	_calc_slope_effort(delta)
	_move(delta)
	_animate()
	
	if host.damaged:
		return statemachine.damage_state
	if Input.is_action_just_pressed("jump"):
		return statemachine.jump_state
	if host.velocity.length() < 5.0:
		return statemachine.walk_state
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
	var delta_accel = delta * (host.roll_control * host.slide_multiplier_area.slide)
	var transmitted_vel = host.linear_velocity_area.velocity
	var speed_dir_length = host.effective_speed * host.analog_control_length * host.speed_multiplier_area.speed * host.slope_effort
	host.velocity.x = lerp(host.velocity.x, host.global_transform.basis.z.x * speed_dir_length + transmitted_vel.x, delta_accel)
	host.velocity.z = lerp(host.velocity.z, host.global_transform.basis.z.z * speed_dir_length + transmitted_vel.z, delta_accel)
	host.velocity.y -= host.gravity * delta #* speed_dir_length

	var previous_velocity = host.velocity
	host.velocity = host.move_and_slide(host.velocity)
	if host.bounce_sensor.is_colliding():
		host.velocity = previous_velocity
		_bounce()

func _bounce():
	host.velocity = host.velocity.bounce(host.bounce_sensor.get_collision_normal())
	host.rotation.y = atan2(host.velocity.x, host.velocity.z)
	

func _animate():
	host.glb.spin_speed(
			(abs(host.velocity.x) + abs(host.velocity.z)) / 10.0)
	
func _turn(delta : float, direction : Vector2):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.roll_control)
