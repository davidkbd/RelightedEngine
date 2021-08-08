extends Area

export(NodePath) var button

func activate(activator):
	if get_parent().keys_collected < get_parent().keys_needed:
		_error()
	else:
		_open()
	get_node(button).translation.y = -.2

func deactivate(activator):
	if get_parent().completed: return
	get_node(button).translation.y = .0

func _error():
	pass

func _open():
	get_tree().call_group("GAME_LISTENER", "game_listener_on_goal_opened")
	get_parent().complete()
	queue_free()
