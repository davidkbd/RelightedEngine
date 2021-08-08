extends HBoxContainer

onready var lifes_label = $Lifes

var lifes : int

func player_listener_on_monitor_destroyed(monitor : Monitor):
	match monitor.type:
		Monitor.MonitorType.EXTRA_LIFE: increment(1)

func player_listener_on_life_got():
	increment(1)

func game_listener_on_goal_opened():
	get_tree().call_deferred("call_group", "GAME_LISTENER", "game_listener_on_summary_data_sent", { "lifes": lifes })

func game_listener_on_timed_out():
	increment(-1)
	get_tree().call_group("GAME_LISTENER", "game_listener_on_timeout_data_sent", { "lifes": lifes })

func player_listener_on_dead(plyr):
	increment(-1)
	print("Llamada a game_listener_on_timeout_data_sent esta mal...")
	get_tree().call_group("GAME_LISTENER", "game_listener_on_timeout_data_sent", { "lifes": lifes })

func increment(n : int):
	lifes += n
	_update_lifes()

func _update_lifes():
	lifes_label.text = str(lifes)

func _initialize_values():
	if Progress.data.size() == 0: return
	lifes = Progress.data.lifes

func _ready():
	_initialize_values()
	_update_lifes()
