extends Control

const POSITION_OFFSET := Vector2(.0, -96.0)

onready var timer := $Timer
onready var countdown_label := $CountDown

onready var t : float = .0
var count : int
var player : Player

func player_listener_on_drown_started(plyr):
	player = plyr
	count = 5
	set_process(true)
	_positioning()
	_on_Timer_timeout()
	timer.start()
	show()

func player_listener_on_drown_cancelled(plyr):
	set_process(false)
	timer.stop()
	hide()

func player_listener_on_dead(player):
	set_process(false)
	timer.stop()

func game_listener_on_goal_opened():
	set_process(false)
	timer.stop()

func game_listener_on_timed_out():
	set_process(false)
	timer.stop()

func _positioning():
	var camera = get_viewport().get_camera()
	countdown_label.rect_global_position = \
			camera.unproject_position(
					player.global_transform.origin
			) + POSITION_OFFSET

func _process(delta : float):
	visible = sin(t) < .3
	t += delta * 10.0 * (5.0 - count)
	_positioning()

func _on_Timer_timeout():
	countdown_label.text = str(count)
	count -= 1
	if count < 0:
		timer.stop()
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_dead", player)

func _ready():
	set_process(false)

func _enter_tree():
	hide()
