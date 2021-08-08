tool
extends Control

class_name OptionElement

signal pressed

enum Alignment {
	LEFT,
	CENTER
}

export(Alignment) var alignment : int = Alignment.LEFT setget set_alignment, get_alignment
export(bool)   var show_pointer : float = true
export(String) var text : String
export(String) var method_name : String

onready var exec_tween         : Tween   = $ExecTween
onready var pointer_ok_texture : Texture = load("res://Engine/MainScenes/StartMenu/Textures/OptionPointerOn.png")
onready var pointer_no_texture : Texture = load("res://Engine/MainScenes/StartMenu/Textures/OptionPointerOff.png")

func set_alignment(new_value : int):
	alignment = new_value
	if Engine.editor_hint:
		_update_alignment()

func get_alignment() -> int: return alignment

func select():
	if show_pointer:
		$OptionPointer.texture = pointer_ok_texture
	else:
		unselect()

func unselect():
	$OptionPointer.texture = pointer_no_texture

func execute():
	if method_name == "": return
	emit_signal("pressed")
	$Label.grab_focus()
	if exec_tween.is_active(): return
	exec_tween.interpolate_property(self, "rect_scale:x",
			1.2, 1.0, .2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	exec_tween.start()
	yield(exec_tween, "tween_all_completed")
	get_tree().call_group("MENU_LISTENER", method_name)

func _update_alignment():
	match alignment:
		Alignment.LEFT: $Label.align = Label.ALIGN_LEFT
		Alignment.CENTER: $Label.align = Label.ALIGN_CENTER

func _ready():
	unselect()
	if not Engine.editor_hint:
		_update_alignment()

func _enter_tree():
	$Label.text = text
