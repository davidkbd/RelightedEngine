extends Area

signal damage_collided
signal collided

export(bool) var destructible := true
export(bool) var kamikaze := false

onready var host = get_parent()
onready var enabled := true

func damage_collided(player):
	emit_signal("damage_collided", host, player)
	if not destructible:
		if player.shield_manager.shield_type > -1:
			get_tree().call_group("PLAYER_LISTENER", "player_listener_on_player_damaged", player)
	elif not player.rolling:
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_player_damaged", player)
		if kamikaze:
			host.self_destroy(player)

func collided(player):
	emit_signal("collided", host, player)
	if destructible and player.rolling:
		get_tree().call_group("PLAYER_LISTENER", "player_listener_on_enemy_destroyed", host)
		host.self_destroy(player)
