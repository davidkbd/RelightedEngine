extends RayCast

onready var lray:= $L
onready var rray := $R

onready var ccolliding := false
onready var lcolliding := false
onready var rcolliding := false

func set_enabled(new_value : bool):
	enabled = new_value
	lray.enabled = new_value
	rray.enabled = new_value

func is_colliding():
	ccolliding = .is_colliding()
	lcolliding = lray.is_colliding()
	rcolliding = rray.is_colliding()
	return ccolliding or lcolliding or rcolliding

func get_collision_normal():
	if ccolliding:
		return .get_collision_normal()
	if lcolliding:
		return lray.get_collision_normal()
	if rcolliding:
		return rray.get_collision_normal()
	return null

func _ready():
	set_enabled(enabled)
