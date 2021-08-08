extends MenuOptions

class_name MenuPopup

export(String) var title : String = "menu.popup.xxx.title"
export(String) var text  : String = "menu.popup.xxx.text"
export(String) var method_name_accept : String = "menu_listener_on_xxx"

onready var value = null

func start():
	show()
	set_process(true)
	set_process_input(true)

func stop():
	hide()
	set_process(false)
	set_process_input(false)

func _accept():
	if options.size():
		._accept()

func _popup_accept():
	yield(get_tree().create_timer(.1), "timeout")
	get_tree().call_group("MENU_LISTENER", method_name_accept, value)

func _initialize_options():
	initialize_options()
	_update_selected()

func _ready():
	stop()
	call_deferred("_initialize_options")
	$Title.text = title
	$Text.text = text
