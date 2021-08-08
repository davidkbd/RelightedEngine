extends HBoxContainer

onready var timer := $Timer
onready var time_label := $Time

const PLAYER_LOSS_TIME  := 5.0
const PLAYER_ENEMY_TIME := 5.0

export(float) var time_per_time_item : float = 30.0

onready var shielded : bool = LevelLoadSharedData.player_shield > -1
onready var invincible : bool = false

var time : int
var rest_time : int
var elapsed_time : float
var timer_increment : int

func player_listener_on_monitor_destroyed(monitor : Monitor):
	match monitor.type:
		Monitor.MonitorType.INVINCIBLE: invincible = true
		Monitor.MonitorType.BASIC_SHIELD: shielded = true
		Monitor.MonitorType.SHIELD_1: shielded = true
		Monitor.MonitorType.SHIELD_2: shielded = true
		Monitor.MonitorType.SHIELD_3: shielded = true
		Monitor.MonitorType.SHIELD_4: shielded = true

func player_listener_on_shield_lost(plyr):
	shielded = false

func player_listener_on_prepared(plyr):
	start()

func player_listener_on_time_item_catched(first_time : bool):
	if first_time: increment(time_per_time_item)

func player_listener_on_enemy_destroyed(enemy):
	increment(PLAYER_ENEMY_TIME)

func player_listener_on_player_damaged(plyr):
	if shielded or invincible: return
	increment(-PLAYER_LOSS_TIME)

func game_listener_on_loaded(data : Dictionary):
	time = data.time
	if data.has("timer_countdown") and data.timer_countdown:
		timer_increment = -1
		rest_time = time
	else:
		timer_increment = 1
		rest_time = 0
	elapsed_time = .0
	_update_time()

func game_listener_on_goal_opened():
	get_tree().call_deferred(
			"call_group",
			"GAME_LISTENER",
			"game_listener_on_summary_data_sent",
			{
				"elapsed_time": elapsed_time,
				"rest_time": rest_time
			})
	timer.stop()
	set_process(false)

func boss_listener_on_destroyed():
	timer.stop()
	set_process(false)

func start():
	timer.start()

func increment(n : int):
	rest_time += n
	_update_time()

func _update_time():
	if timer_increment < 0:
		_countdown()
	else:
		_countup()
	time_label.text = TextFormat.timestamp(rest_time)

func _countdown():
	if rest_time < 1:
		rest_time = 0
		_timedout()

func _countup():
	if rest_time >= time:
		rest_time = time
		_timedout()

func _timedout():
	get_tree().call_group("GAME_LISTENER", "game_listener_on_timed_out")
	timer.stop()

func _on_Timer_timeout():
	increment(timer_increment)

func _process(delta : float):
	elapsed_time += delta
