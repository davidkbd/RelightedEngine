extends Node

onready var shield_type : int = -1

func player_listener_on_monitor_destroyed(monitor):
	match monitor.type:
		Monitor.MonitorType.BASIC_SHIELD: shield_type = 0
		Monitor.MonitorType.SHIELD_1: shield_type = 1
		Monitor.MonitorType.SHIELD_2: shield_type = 2
		Monitor.MonitorType.SHIELD_3: shield_type = 3
		Monitor.MonitorType.SHIELD_4: shield_type = 4

func player_listener_on_shield_lost(plyr):
	if plyr == get_parent():
		shield_type = -1

func has_shield():
	return shield_type > -1

func _ready():
	shield_type = LevelLoadSharedData.player_shield
