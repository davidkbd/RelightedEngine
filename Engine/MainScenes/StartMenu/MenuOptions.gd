extends Control

class_name MenuOptions

signal option_changed(new_opt)

enum Direction {
	DOWN,
	RIGHT
}

export(Direction) var direction : int = Direction.DOWN

onready var options := []
onready var selected_option := 0

func initialize_options():
	print("Not implemented (initialize_options)")

func _process(delta : float):
	match direction:
		Direction.DOWN: _process_down()
		Direction.RIGHT: _process_right()

func _process_down():
	if Input.is_action_just_pressed("ui_up"):
		_select_option(-1)
	elif Input.is_action_just_pressed("ui_down"):
		_select_option(1)
	elif Input.is_action_just_pressed("ui_accept"):
		_accept()

func _process_right():
	if Input.is_action_just_pressed("ui_left"):
		_select_option(-1)
	elif Input.is_action_just_pressed("ui_right"):
		_select_option(1)
	elif Input.is_action_just_pressed("ui_accept"):
		_accept()

func _select_option(incr : int):
	if options.size() < 1: return
	selected_option = clamp(selected_option + incr, 0, options.size() - 1)
	_update_selected()

func _accept():
	if options.size() < 1: return
	options[selected_option].execute()

func _update_selected():
	if options.size() < 1: return
	emit_signal("option_changed", selected_option)
	for opt in options:
		opt.unselect()
	options[selected_option].select()
