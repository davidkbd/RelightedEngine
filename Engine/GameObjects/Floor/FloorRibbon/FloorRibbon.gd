extends MeshInstance

export(Vector3) var velocity := Vector3.FORWARD * .5
export(Material) var ribbon_material

func _ready():
	material_override = ribbon_material.duplicate()
	var speed =  Vector2(velocity.x, velocity.z) * .5 #* 2.14
	material_override.set_shader_param("speed_angle", speed.angle())
	material_override.set_shader_param("speed_length", speed.length())
