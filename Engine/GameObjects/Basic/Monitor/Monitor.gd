tool
extends StaticBody

class_name Monitor

enum MonitorType {
	EXTRA_LIFE,
	SPEED,
	RINGS_10,
	RINGS_50,
	INVINCIBLE,
	BASIC_SHIELD,
	SHIELD_1, # Fire
	SHIELD_2, # Electric
	SHIELD_3, # Bubble
	SHIELD_4, # Ice
	NOT_DEFINED_1,
	NOT_DEFINED_2
}

export(Resource) var model : Resource setget set_model, get_model
export(MonitorType) var type : int setget set_type, get_type
export(Resource) var icons : Resource setget set_icons, get_icons

func set_model(new_value : Resource):
	model = new_value
	if Engine.editor_hint: _update_model()

func get_model() -> Resource: return model

func set_type(new_value : int):
	type = new_value
	if Engine.editor_hint and $Model: _update_icons()

func get_type() -> int: return type

func set_icons(new_value : Resource):
	icons = new_value
	if Engine.editor_hint and $Icon: _update_icons()

func get_icons() -> Resource: return icons

func self_destroy(player):
	VfxEmitter.mini_explosion(global_transform.origin)
	queue_free()

func _update_model():
	$Model.mesh = model

func _update_icons():
	$Icon.texture = icons
	$Icon.frame = type

func _ready():
	if not Engine.editor_hint:
		_update_model()
		_update_icons()
