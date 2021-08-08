extends MenuScreen

func start():
	$AnimationPlayer.play("start")
	.start()

func stop():
	$AnimationPlayer.play("stop")

func _animation_end_stop():
	.stop()

func initialize_options():
	options = $Options.get_children()

func _any_button_pressed():
	.set_process(false)
#
#func _enter_tree():
#	get_tree().call_group("MENU_LISTENER", "menu_listener_on_principal_opened")
