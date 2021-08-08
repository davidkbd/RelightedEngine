extends Node

export(float) var duration := .5

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

var time : float

func enter():
	host.rolling = false
	host.glb.damage()
	time = duration
	host.body_colllision_area.enable()

func exit():
	host.damaged = false
	host.body_colllision_area.disable()

func step(delta : float):
	_move(delta)
	time -= delta
	if time <= .0: return statemachine.idle_state
	return self

func _move(delta : float):
	var delta_accel = delta
	var transmitted_vel = host.linear_velocity_area.velocity
	host.velocity.x = lerp(host.velocity.x, .0, delta_accel) + transmitted_vel.x
	host.velocity.z = lerp(host.velocity.z, .0, delta_accel) + transmitted_vel.z
	host.velocity.y -= host.gravity * delta
	host.velocity = host.move_and_slide(host.velocity)
	host.velocity -=  transmitted_vel
