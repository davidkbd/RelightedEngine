extends Spatial

var player_template : PackedScene

var player_instance : Player

func game_listener_on_loaded(data : Dictionary):
	player_template = data.character
	player_instance = player_template.instance()

func game_listener_on_title_shown():
	$AnimationPlayer.play("Start")
	get_tree().call_deferred("call_group",
			"PLAYER_LISTENER", "player_listener_on_start_point_prepared", self)

func instance_player():
	get_parent().add_child(player_instance)
	player_instance.global_transform.origin = global_transform.origin
	var x = abs(player_instance.global_transform.origin.x - floor(player_instance.global_transform.origin.x))
	if x < .1:
		player_instance.global_transform.origin.x += .1
	var z = abs(player_instance.global_transform.origin.z - floor(player_instance.global_transform.origin.z))
	if z < .1:
		player_instance.global_transform.origin.z += .1

func _on_Timer_timeout():
	instance_player()
	queue_free()
