extends Area

onready var host := get_parent()

func _on_WaterFreezerArea_area_entered(area):
	if host.shield_manager.shield_type == Constants.RelightedEngineShieldTypes.ICE:
		area.freeze()
	else:
		VfxEmitter.water_splash(global_transform.origin, host.velocity.length())
	if host.shield_manager.shield_type == Constants.RelightedEngineShieldTypes.FIRE \
	or host.shield_manager.shield_type == Constants.RelightedEngineShieldTypes.ELECTRIC:
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_shield_lost", host) 

func _on_WaterFreezerArea_area_exited(area):
	if host.shield_manager.shield_type == Constants.RelightedEngineShieldTypes.ICE:
		area.unfreeze()
	else:
		VfxEmitter.water_splash(global_transform.origin, host.velocity.length())
