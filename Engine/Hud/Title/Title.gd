extends Control

func game_listener_on_loaded(data : Dictionary):
	$LevelName.text = tr("zone." + data.zone + ".name")
	$ActNumber.text = data.act
	$AnimationPlayer.play("show")

func _emit_signal():
	get_tree().call_group("GAME_LISTENER", "game_listener_on_title_shown")

func done():
	queue_free()
