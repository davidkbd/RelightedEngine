extends MenuScreen

onready var event_json_transformer := $InputEventJsonTransformer

func settings_listener_on_applied(data : Dictionary):
	_update_input("du",   event_json_transformer.transform_to_event(data.inputs.du))
	_update_input("dd",   event_json_transformer.transform_to_event(data.inputs.dd))
	_update_input("dl",   event_json_transformer.transform_to_event(data.inputs.dl))
	_update_input("dr",   event_json_transformer.transform_to_event(data.inputs.dr))
	_update_input("jump", event_json_transformer.transform_to_event(data.inputs.jump))
	_update_input("spin", event_json_transformer.transform_to_event(data.inputs.spin))
	_update_labels()

func menu_listener_on_input_jump_entered(value):
	_update_input("jump", value)
	_update_labels()

func menu_listener_on_input_spindash_entered(value):
	_update_input("spin", value)
	_update_labels()

func start():
	$AnimationPlayer.play("start")
	.start()

func stop():
	$AnimationPlayer.play("stop")

func _animation_end_stop():
	.stop()

func initialize_options():
	options = [ $Options/InputMapJump, $Options/InputMapSpindash, $Options/Back ]

func _inputs_to_json() -> Dictionary:
	return {
		"du":   event_json_transformer.transform_to_json(_get_event("du")),
		"dd":   event_json_transformer.transform_to_json(_get_event("dd")),
		"dl":   event_json_transformer.transform_to_json(_get_event("dl")),
		"dr":   event_json_transformer.transform_to_json(_get_event("dr")),
		"jump": event_json_transformer.transform_to_json(_get_event("jump")),
		"spin": event_json_transformer.transform_to_json(_get_event("spin"))
	}

func _update_labels():
	$Options/InputMapJump/Value.text = OS.get_scancode_string(_get_event("jump").scancode)
	$Options/InputMapSpindash/Value.text = OS.get_scancode_string(_get_event("spin").scancode)

func _get_event(action : String):
	var evts = InputMap.get_action_list(action)
	return evts[evts.size() - 1]

func _update_input(action : String, event : InputEvent, max_count : int = 0):
	var evts = InputMap.get_action_list(action)
	while evts.size() > max_count: evts.remove(max_count)
	evts.append(event)
	InputMap.action_erase_events(action)
	for evt in evts:
		InputMap.action_add_event(action, evt)

func _save_settings():
	Settings.settings.inputs = _inputs_to_json()

func _process(delta : float):
	if selected_option == options.size() - 1:
		if Input.is_action_just_pressed("ui_accept"):
			_save_settings()

func _any_button_pressed():
	.set_process(false)
#
#func _enter_tree():
#	get_tree().call_group("MENU_LISTENER", "menu_listener_on_controls_opened")
