extends Area

onready var enabled := true

func damage_collided(player):
	get_tree().call_group("PLAYER_LISTENER", "player_listener_on_player_damaged", player)

func enable():
	enabled = true
	set_collision_mask_bit(6, enabled)

func _on_Tween_tween_all_completed():
	enabled = translation.y >= -.1
	set_collision_mask_bit(6, enabled)
