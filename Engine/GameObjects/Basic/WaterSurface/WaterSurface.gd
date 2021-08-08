extends MeshInstance

export(Vector2) var size := Vector2.ONE

onready var freeze_tween := $FreezeTween
onready var body := $StaticBody
onready var collishape := $StaticBody/CollisionShape

var water_material : ShaderMaterial
var ice_material   : ShaderMaterial

func player_listener_on_player_damaged(plyr):
	if body.collision_layer: unfreeze()

func freeze():
	body.collision_layer = 1025
	body.collision_mask = 1025
	_start_tween(.0, 1.0)

func unfreeze():
	body.collision_layer = 0
	body.collision_mask = 0
	_start_tween(1.0, .0)

func _start_tween(from : float, to : float):
	freeze_tween.stop_all()
	freeze_tween.resume_all()
	freeze_tween.interpolate_property(
			ice_material, "shader_param/disolve",
			from, to, .5,
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	freeze_tween.start()

func _prepare_material():
	var real_size := size * 5.0
	water_material = mesh.surface_get_material(0).duplicate(true)
	mesh.surface_set_material(0, water_material)
	water_material.set_shader_param("tile", real_size)
	
	ice_material = water_material.next_pass

func _prepare_body():
	collishape.shape = collishape.shape.duplicate()
	collishape.shape.extents.x = size.x * .5
	collishape.shape.extents.z = size.y * .5

func _prepare_mesh():
	mesh = mesh.duplicate(true)
	mesh.size = size

func _ready():
	_prepare_mesh()
	_prepare_material()
	_prepare_body()
	unfreeze()
