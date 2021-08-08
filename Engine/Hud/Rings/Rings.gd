extends HBoxContainer

onready var rings_label := $Rings

onready var rings    : int = LevelLoadSharedData.rings_to_instantiate
onready var shielded : bool = LevelLoadSharedData.player_shield > -1
onready var invincible : bool = false

func player_listener_on_monitor_destroyed(monitor : Monitor):
	match monitor.type:
		Monitor.MonitorType.RINGS_10: increment(10)
		Monitor.MonitorType.RINGS_50: increment(50)
		Monitor.MonitorType.INVINCIBLE: invincible = true
		Monitor.MonitorType.BASIC_SHIELD: shielded = true
		Monitor.MonitorType.SHIELD_1: shielded = true
		Monitor.MonitorType.SHIELD_2: shielded = true
		Monitor.MonitorType.SHIELD_3: shielded = true
		Monitor.MonitorType.SHIELD_4: shielded = true

func player_listener_on_shield_lost(plyr):
	shielded = false

func player_listener_on_player_damaged(plyr):
	if shielded or invincible: return
	if EngineConfig.LOSS_ALL_RINGS_ON_DAMAGE:
		reset()
	else:
		increment(-Constants.MAX_PLAYER_LOSS_RINGS)

func player_listener_on_ring_catched():
	increment(1)

func game_listener_on_goal_opened():
	get_tree().call_deferred("call_group", "GAME_LISTENER", "game_listener_on_summary_data_sent", { "rings": rings })

func reset():
	rings = 0
	_update_rings()

func increment(n : int):
	rings = clamp(rings + n, 0, Constants.MAX_PLAYER_RINGS)
	_update_rings()

func has_rings() -> bool:
	return rings > 0

func _update_rings():
	rings_label.text = str(rings)

func _ready():
	print(rings)
	_update_rings()
