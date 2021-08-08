extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

var impulsed : bool

func enter():
	if host.impulsed:
		host.rolling = false
		_impulse()
	else:
		if not host.rolling:
			host.glb.fall_down()
	host.body_colllision_area.enable()

func exit():
	host.body_colllision_area.disable()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	_move(delta)
	if host.impulsed: _impulse()
	_animate()
	
	if host.damaged:
		return statemachine.damage_state
	if Input.is_action_just_pressed("jump"):
		return statemachine.bubble_drop_state
	if host.floor_raycast_result.size():
		return statemachine.idle_state
	if host.teleport:
		return statemachine.teleport_state
	return self

func _animate():
	if impulsed:
		if host.velocity.y < .0:
			host.glb.fall_down()

func _impulse():
	impulsed = host.impulsed != null
	host.glb.fall_up()
	host.velocity = host.impulsed
	host.impulsed = null

func _move(delta : float):
	var delta_accel = delta * host.air_control
	var transmitted_vel = host.linear_velocity_area.velocity
	var speed_dir_length = host.effective_speed * host.analog_control_length * host.speed_multiplier_area.speed
	host.velocity.x = lerp(host.velocity.x, host.global_transform.basis.z.x * speed_dir_length + transmitted_vel.x, delta_accel)
	host.velocity.z = lerp(host.velocity.z, host.global_transform.basis.z.z * speed_dir_length + transmitted_vel.z, delta_accel)
	host.velocity.y -= host.gravity * delta
	host.velocity = host.move_and_slide(host.velocity, Vector3.UP)

func _turn(delta : float):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.turn_speed * host.acceleration)
