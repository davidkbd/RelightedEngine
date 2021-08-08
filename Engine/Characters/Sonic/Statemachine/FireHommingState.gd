extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

var target : Spatial

var impulsed : bool

func enter():
	host.rolling = true
	host.glb.jump()
	host.body_colllision_area.enable()
	host.set_collision_layer_bit(0, false)
	host.vfx.fire_shield_homing_begin()

func exit():
	host.body_colllision_area.disable()
	host.set_collision_layer_bit(1, true)
	host.vfx.fire_shield_homing_end()

func step(delta : float):
	if host.analog_control_length > .1:
		_turn(delta)
	if host.floor_raycast_result.size() or not is_instance_valid(target):
		return statemachine.fall_state
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
	var destination : Vector3 = target.global_transform.origin - host.global_transform.origin
	
	host.velocity = destination.normalized() * host.fire_shield_homing_speed
	host.velocity = host.move_and_slide(host.velocity, Vector3.UP)

func _turn(delta : float):
	host.rotation.y = lerp_angle(
			host.rotation.y,
			host.camera_rotation - host.analog_control_angle,
			delta * host.turn_speed * host.acceleration)
