extends Area

func _on_ActivationArea_area_entered(area):
	area.activate(get_parent())

func _on_ActivationArea_area_exited(area):
	area.deactivate(get_parent())
