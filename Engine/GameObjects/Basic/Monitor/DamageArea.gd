extends Area

export(int) var type : int = 0

onready var host = get_parent()

func damage_collided(player):
	pass

func collided(player):
	if not player.rolling: return
	get_tree().call_group("PLAYER_LISTENER", "player_listener_on_monitor_destroyed", host)
	host.self_destroy(player)
