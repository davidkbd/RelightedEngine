extends Area

func activate(activator):
	get_parent().activate()

func deactivate(activator):
	get_parent().deactivate()

func _ready():
	call_deferred("deactivate", null)
