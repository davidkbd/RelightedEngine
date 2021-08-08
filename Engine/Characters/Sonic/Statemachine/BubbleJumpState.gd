extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

func enter():
	host.rolling = true
	host.glb.jump()
	if statemachine.previous_state == statemachine.bubble_drop_state:
		host.velocity = statemachine.previous_state.bounce
	else:
		if host.floor_raycast_result.size():
			host.velocity += host.floor_raycast_result.normal * host.jump_force
		else:
			host.velocity.y += host.jump_force
	host.body_colllision_area.enable()

func exit():
	host.body_colllision_area.disable()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	_move(delta)
	_animate()
	
	if host.damaged:
		return statemachine.damage_state
	if Input.is_action_just_pressed("jump"):
		return statemachine.bubble_drop_state
	if host.is_on_floor() and host.floor_raycast_result.size():
		return statemachine.idle_state
	if host.teleport:
		return statemachine.teleport_state
	if host.impulsed:
		return statemachine.fall_state
	return self

func _animate():
	host.glb.run_speed(
			(abs(host.velocity.x) + abs(host.velocity.z)) / 2.0)

func _move(delta : float):
	var delta_accel = delta * host.air_control
	var transmitted_vel = host.linear_velocity_area.velocity
	var speed_dir_length = host.effective_speed * host.analog_control_length * host.speed_multiplier_area.speed
	var calcv_x = host.global_transform.basis.z.x * speed_dir_length + transmitted_vel.x
	var calcv_z = host.global_transform.basis.z.z * speed_dir_length + transmitted_vel.z
	host.velocity.x = lerp(host.velocity.x, calcv_x, delta_accel)
	host.velocity.z = lerp(host.velocity.z, calcv_z, delta_accel)
	host.velocity.y -= host.gravity * delta
	host.velocity = host.move_and_slide(
			host.velocity, Vector3.UP,
			false, 4, .78, true)

func _turn(delta : float):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.turn_speed * host.acceleration)

