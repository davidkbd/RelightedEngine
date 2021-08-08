extends Node

onready var host := get_parent()

onready var shield_type : int = -1

func player_listener_on_monitor_destroyed(monitor):
	match monitor.type:
		Monitor.MonitorType.BASIC_SHIELD: _active(Constants.RelightedEngineShieldTypes.BASIC)
		Monitor.MonitorType.SHIELD_1: _active(Constants.RelightedEngineShieldTypes.FIRE)
		Monitor.MonitorType.SHIELD_2: _active(Constants.RelightedEngineShieldTypes.ELECTRIC)
		Monitor.MonitorType.SHIELD_3: _active(Constants.RelightedEngineShieldTypes.BUBBLE)
		Monitor.MonitorType.SHIELD_4: _active(Constants.RelightedEngineShieldTypes.ICE)

func game_listener_on_goal_opened():
	get_tree().call_deferred("call_group", "GAME_LISTENER", "game_listener_on_summary_data_sent", { "player_shield": shield_type })

func player_listener_on_shield_lost(plyr):
	if plyr == get_parent():
		_active(-1)

func has_shield():
	return shield_type > -1

func _active(id : int):
	shield_type = id
	host.vfx.set_shield(id)
	host.statemachine.set_shield(id)

func _ready():
	call_deferred("_active", LevelLoadSharedData.player_shield)
