extends Area

onready var host := get_parent()

var target : Spatial

func activate(activator):
	target = activator
	host.start_attack()
	
func deactivate(activator):
	target = null
	host.start_walk()
