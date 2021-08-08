extends Area

func disable():
	set_collision_layer_bit(7, false)

func enable():
	set_collision_layer_bit(7, true)

func _on_BodyCollisionArea_area_entered(area):
	area.collided(get_parent())
