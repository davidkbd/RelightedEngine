extends Node

onready var statemachine := get_parent()
onready var host := statemachine.get_parent()

func enter():
	host.glb.idle()
	host.global_transform = host.teleport
	host.velocity = Vector3.ZERO
#	host.body_colllision_area.enable()

func exit():
#	host.body_colllision_area.disable()
	pass

func step(delta : float):
	if host.teleport == null: return statemachine.idle_state
	if host.damaged:
		return statemachine.damage_state
	return self

func _on_VisibilityNotifier_camera_entered(camera):
	host.teleport = null
