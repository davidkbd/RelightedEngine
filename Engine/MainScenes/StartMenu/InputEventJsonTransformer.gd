extends Node

func transform_to_event(json : Dictionary) -> InputEvent:
	var evt : InputEvent
	if json.type == "InputEventKey":
		evt = InputEventKey.new()
		evt.scancode = int(json.code1)
	elif json.type == "InputEventJoypadMotion":
		evt = InputEventJoypadMotion.new()
		evt.axis = int(json.code1)
		evt.axis_value = float(json.code2)
	elif json.type == "InputEventJoypadButton":
		evt = InputEventJoypadButton.new()
		evt.button_index = int(json.code1)
		evt.pressure = float(json.code2)
	return evt

func transform_to_json(d : InputEvent) -> Dictionary:
	var type : String
	var code1 : int
	var code2 : float
	if d is InputEventKey:
		type = "InputEventKey"
		code1 = d.scancode
	if d is InputEventJoypadMotion:
		type = "InputEventJoypadMotion"
		code1 = d.axis
		code2 = d.axis_value
	elif d is InputEventJoypadButton:
		type = "InputEventJoypadButton"
		code1 = d.button_index
		code2 = d.pressure
	return {"type": type, "code1": code1, "code2": code2}
