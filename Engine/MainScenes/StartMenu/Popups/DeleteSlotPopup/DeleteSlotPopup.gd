extends MenuPopup

func menu_listener_on_slots_popup_cancelled():
	value = {"accepted": false }
	_popup_accept()

func menu_listener_on_slots_popup_accepted():
	value = {"accepted": true, "value": value }
	_popup_accept()

func start():
	selected_option = 0
	_update_selected()
	.start()

func initialize_options():
	options = $Options.get_children()
