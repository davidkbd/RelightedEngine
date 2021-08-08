extends Spatial

export(float) var speed := 10.0

export(Array, PackedScene) var particle_systems := []
export(Array, PackedScene) var vfxs := []
export(Array, PackedScene) var other_objects := []
export(bool) var autocache_eneimes := true

func game_listener_on_title_shown():
	queue_free()

func _physics_process(delta : float):
	global_transform.origin.y += delta * speed * 2.0
	rotation.y += delta * speed

func _instance_particles():
	for tmplt in particle_systems:
		var inst = tmplt.instance()
		add_child(inst)
		inst.emit()

func _instance_vfxs():
	for tmplt in vfxs:
		var inst = tmplt.instance()
		add_child(inst)
		inst.show()
		for child in inst.get_children():
			if child is CPUParticles:
				child.emitting = true
			elif child is Particles:
				child.emitting = true

func _instance_other_objects():
	for tmplt in other_objects:
		var inst = tmplt.instance()
		add_child(inst)

func _clone_enemies():
	for obj in get_tree().get_nodes_in_group("ENEMY"):
		$Duplicator.duplicate_object(obj)

func _start():
	_instance_particles()
	_instance_vfxs()
	_instance_other_objects()
	if autocache_eneimes:
		_clone_enemies()

func _ready():
	call_deferred("_start")
