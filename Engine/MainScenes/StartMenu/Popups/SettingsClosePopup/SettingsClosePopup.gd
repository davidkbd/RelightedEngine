extends MenuPopup

func menu_listener_on_options_popup_cancelled():
	value = false
	_popup_accept()

func menu_listener_on_options_popup_accepted():
	value = true
	_popup_accept()

func initialize_options():
	options = $Options.get_children()
