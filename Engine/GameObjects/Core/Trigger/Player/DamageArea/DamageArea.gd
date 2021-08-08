extends Area

onready var restore_timer := $RestoreTimer

func player_listener_on_player_damaged(plyr):
	if plyr == get_parent():
		restore_timer.start()
		set_collision_layer_bit(6, false)

func _on_RestoreTimer_timeout():
	set_collision_layer_bit(6, true)

func _on_DamageArea_area_entered(area):
	area.damage_collided(get_parent())

func _ready():
	restore_timer.wait_time = Constants.INVINCIBLE_POST_DAMAGE_TIME
