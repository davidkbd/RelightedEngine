extends Area

export(String) var group_name : String = "HOMING_OBJECTIVE"

onready var host := get_parent()

func activate(activator):
	host.add_to_group(group_name)

func deactivate(activator):
	if host.is_in_group(group_name):
		host.remove_from_group(group_name)

func _ready():
	call_deferred("deactivate", null)
