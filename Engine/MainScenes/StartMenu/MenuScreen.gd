extends MenuOptions

class_name MenuScreen

func start():
	show()
	set_process(true)
	# Si es la ultima opcion (volver), seleccionamos la primera opcion
	if selected_option == options.size() - 1:
		_select_option(-10000)

func stop():
	hide()
	set_process(false)

func pause():
	set_process(false)

func resume():
	set_process(true)

func _initialize_options():
	initialize_options()
	_update_selected()

func _enter_tree():
	stop()
	call_deferred("_initialize_options")
