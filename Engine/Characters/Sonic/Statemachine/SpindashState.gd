extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

var time : float

func enter():
	host.rolling = true
	host.glb.spin()
	time = .0
	host.body_colllision_area.enable()

func exit():
	host.body_colllision_area.disable()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	_move(delta)
	_count_time(delta)
	_animate()

	if time > 3.5:
		return statemachine.idle_state
	if host.damaged:
		return statemachine.damage_state
	if Input.is_action_just_released("spin"):
		_impulse()
		return statemachine.roll_state
	if host.teleport:
		return statemachine.teleport_state
	if host.floor_raycast_result.size() == 0:
		return statemachine.fall_state
	return self

func _count_time(delta : float):
	time += delta

func _animate():
	host.glb.spin_speed(clamp(time, 1.0, 3.0) / 3.0)

func _impulse():
	var force = host.spindash_force * (1.0 + clamp(time, .0, 3.0) * .5)
	host.velocity = host.global_transform.basis.z * force * host.effective_speed

func _move(delta : float):
	var delta_accel = delta * host.slide_multiplier_area.slide
	var movement = host.linear_velocity_area.velocity
	host.velocity.x = movement.x
	host.velocity.z = movement.z
	host.velocity.y -= host.gravity * delta
	host.velocity = host.move_and_slide(host.velocity)

func _turn(delta : float):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.turn_speed)
