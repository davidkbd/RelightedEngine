extends Control

func menu_listener_on_title_opened():
	_show($Principal)

func menu_listener_on_principal_opened():
	_show($Principal)

func menu_listener_on_slots_opened():
	_show($Slots)

func menu_listener_on_options_opened():
	_show($Options)

func menu_listener_on_controls_opened():
	_show($Controls)

func menu_listener_on_credits_opened():
	_show($Credits)

func menu_listener_on_settings_popup_closed(result):
	_show($Principal)

func menu_listener_on_controls_closed():
	_show($Options)

func menu_listener_on_credits_closed():
	_show($Principal)

func _show(node : Control):
	for child in get_children():
		print(child.get_path())
		child.hide()
	node.show()
