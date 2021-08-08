extends Area

onready var host := get_parent()
onready var timer := $Timer

onready var underwater : bool = false

func player_listener_on_underwater_breathed(plyr):
	if underwater:
		_begin_suffocation()

func player_listener_on_monitor_destroyed(monitor):
	if monitor.type == Constants.RelightedEngineShieldTypes.BUBBLE:
		timer.stop()

func player_listener_on_shield_lost(player):
	if underwater:
		_begin_suffocation()

func player_listener_on_dead(player):
	timer.stop()

func game_listener_on_goal_opened():
	timer.stop()

func game_listener_on_timed_out():
	timer.stop()

func _on_WaterSurfaceArea_area_entered(area):
	if host.shield_manager.shield_type != Constants.RelightedEngineShieldTypes.BUBBLE:
		underwater = true
		_begin_suffocation()
	VfxEmitter.water_splash(global_transform.origin, host.velocity.length())

func _on_WaterSurfaceArea_area_exited(area):
	if host.shield_manager.shield_type != Constants.RelightedEngineShieldTypes.BUBBLE:
		underwater = false
		_cancel_suffocation()
	VfxEmitter.water_splash(global_transform.origin, host.velocity.length())

func _cancel_suffocation():
	if timer.is_stopped(): 
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_drown_cancelled", host)
	timer.stop()

func _begin_suffocation():
	if timer.is_stopped():
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_drown_cancelled", host)
	timer.start()

func _on_Timer_timeout():
	get_tree().call_group("PLAYER_LISTENER", "player_listener_on_drown_started", host)

func _ready():
	timer.wait_time = Constants.PLAYER_MAX_UNDERWATER_SECONDS
