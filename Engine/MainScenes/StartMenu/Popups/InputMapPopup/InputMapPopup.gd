extends MenuPopup

func _input(event : InputEvent):
	if event.is_pressed():
		value = event
		_popup_accept()
