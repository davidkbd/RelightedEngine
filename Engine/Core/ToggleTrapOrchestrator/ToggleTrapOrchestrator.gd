extends Node

export(float) var time_on : float = 1.0#2.0
export(float) var time_off : float = 3.0

onready var timer := $Timer
onready var status := false

func player_listener_on_prepared(plyr):
	_toggle()

func game_listener_on_goal_opened():
	timer.stop()

func game_listener_on_timed_out():
	timer.stop()

func player_listener_on_dead(plyr):
	timer.stop()

func _toggle():
	if status:
		get_tree().call_group("TOGGLE_TRAP", "toggle_trap_listener_on_activate")
		timer.start(time_on)
	else:
		get_tree().call_group("TOGGLE_TRAP", "toggle_trap_listener_on_deactivate")
		timer.start(time_off)
	status = !status

func _on_Timer_timeout():
	_toggle()

