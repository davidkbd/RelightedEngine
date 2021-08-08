extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

func enter():
	host.glb.win(.0)
	host.velocity = Vector3.ZERO
	host.rotation.y = -host.camera_rotation
	host.update_analog_control(Vector2.ZERO)

func exit():
	host.damaged = false

func step(delta : float):
	_move(delta)
	return self

func _move(delta : float):
	var delta_accel = delta
	var transmitted_vel = host.linear_velocity_area.velocity
	host.velocity.x = lerp(host.velocity.x, .0, delta_accel) + transmitted_vel.x
	host.velocity.z = lerp(host.velocity.z, .0, delta_accel) + transmitted_vel.z
	host.velocity.y -= host.gravity * delta
	host.velocity = host.move_and_slide(host.velocity)
	host.velocity -=  transmitted_vel
