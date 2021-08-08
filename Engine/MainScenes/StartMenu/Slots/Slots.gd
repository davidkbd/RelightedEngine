extends MenuScreen

export(int) var scroll_size := 450

enum ClickMode {
	PLAY,
	DELETE
}

var click_mode : int

func menu_listener_on_slots_poup_closed(data):
	if data.accepted:
		var slot_id = data.value
		Progress.reset(slot_id)
		LevelLoadSharedData.reset(slot_id)
		_update_slots_data()
	_update_click_mode(ClickMode.PLAY)

func start():
	_update_click_mode(ClickMode.PLAY)
	$AnimationPlayer.play("start")
	.start()
	_update_slots_data()

func stop():
	$AnimationPlayer.play("stop")

func _animation_end_stop():
	.stop()

func initialize_options():
	options = []
	for game in $OptionsScroll/Options.get_children():
		if game is StartMenuSlotElement:
			options.append(game.get_option_element())
		else:
			options.append(game.get_child(1))
	options.append($Back)

func _update_slots_data():
	var normal_color = Color.white
	var empty_color = Color(1, 1, 1, .4)
	for game in $OptionsScroll/Options.get_children():
		if game is StartMenuSlotElement:
			var slot = game.get_index() + 1
			game.set_empty(Progress.is_slot_empty(slot))

func _update_click_mode(new_node : int):
	click_mode = new_node
	$ClickPlayText.visible = click_mode == ClickMode.PLAY
	$ClickDeleteText.visible = click_mode == ClickMode.DELETE
	for game in $OptionsScroll/Options.get_children():
		if game is StartMenuSlotElement:
			var slot = game.get_index() + 1
			game.set_deleting(click_mode == ClickMode.DELETE)

func _on_Slots_option_changed(new_opt):
	var pos = new_opt
	var n = options.size() - 2
	get_tree().call_group(
			"MENU_LISTENER",
			"menu_listener_on_slot_changed",
			options[new_opt].get_parent())
	$OptionsScroll.scroll_horizontal = \
			(scroll_size / n) * pos

func _on_Option_pressed(slot_id : int):
	if click_mode == ClickMode.PLAY:
		get_tree().call_group(
				"MENU_LISTENER",
				"menu_listener_on_new_game_created",
				slot_id)
	else:
		get_tree().call_group(
				"MENU_LISTENER",
				"menu_listener_on_slot_selected_to_removed",
				slot_id)

func _on_Delete_pressed():
	if click_mode == ClickMode.PLAY:
		_update_click_mode(ClickMode.DELETE)
	else:
		_update_click_mode(ClickMode.PLAY)
#
#func _enter_tree():
#	get_tree().call_group("MENU_LISTENER", "menu_listener_on_slots_opened")
