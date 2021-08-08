extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

var bounce : Vector3

var impulsed : bool

func enter():
	host.rolling = true
	host.glb.jump()
	bounce = Vector3.ZERO
	host.velocity = host.bubble_shield_impulse
	host.body_colllision_area.enable()
	host.set_collision_layer_bit(0, false)
	host.vfx.bubble_shield_impulse()

func exit():
	_convert_bounce()
	host.body_colllision_area.disable()
	host.set_collision_layer_bit(1, true)
	host.vfx.bubble_shield_bounce()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	if host.floor_raycast_result.size():
		return statemachine.jump_state
	_move(delta)
	if host.impulsed: _impulse()
	_animate()
	
	if host.damaged:
		return statemachine.damage_state
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
	bounce = host.velocity
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

func _convert_bounce():
	if host.floor_raycast_result.size():
		bounce = bounce.bounce(host.floor_raycast_result.normal)
	else:
		bounce = bounce.bounce(Vector3.UP)
	if bounce.length() > host.bubble_shield_bounce_max_length:
		bounce = bounce.normalized() * host.bubble_shield_bounce_max_length
