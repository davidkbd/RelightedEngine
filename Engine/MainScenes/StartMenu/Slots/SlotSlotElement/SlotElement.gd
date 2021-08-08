tool
extends Control

class_name StartMenuSlotElement

signal pressed

export(bool) var selected : bool = false setget set_selected, is_selected
export(bool) var empty    : bool = false setget set_empty, is_empty
export(bool) var deleting : bool = false setget set_deleting, is_deleting

func set_selected(new_value : bool):
	selected = new_value
	_update_selection()

func is_selected() -> bool: return selected

func set_empty(new_value : bool):
	empty = new_value
	_update_selection()

func is_empty() -> bool: return empty

func set_deleting(new_value : bool):
	deleting = new_value
	_update_selection()

func is_deleting() -> bool: return deleting

func menu_listener_on_slot_changed(option):
	set_selected(option == self)

func get_option_element():
	return $Option

func _update_selection():
	$SelectionFrame.visible = selected
	$NotSelectedFrame.visible = !selected
	$Image.modulate = Color(1.0, 1.0, 1.0, .5) if empty else Color.white
	$EmptyLabel.visible = empty and not deleting
	$DeleteLabel.visible = deleting and not empty
	modulate = Color(1.2, .4, .4) if deleting and not selected else Color.white

func _on_Option_pressed():
	emit_signal("pressed")
	if $ExecTween.is_active(): return
	$ExecTween.interpolate_property(self, "rect_scale:y",
		rect_scale.y * .9, rect_scale.y, .1, Tween.TRANS_SINE, Tween.EASE_OUT)
	$ExecTween.start()
