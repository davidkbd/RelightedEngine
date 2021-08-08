extends Spatial

onready var model := $Model
onready var ray_position := $RayPosition

onready var step := 1
onready var t := .0

func _physics_process(delta):
	match step:
		1: _step_1(delta)
		2: _step_2(delta)
		3: _step_3(delta)
	t += delta

func _step_1(delta : float):
	translation += global_transform.basis.z * delta * .9
	translation.y = cos(t)
	if translation.y <= .0:
		model.idle()
		step += 1
		t = .0

func _step_2(delta : float):
	if t > rand_range(.0, 10.0):
		rotation.y = rand_range(-PI, PI)
		step += 1
		model.fly()
		t = .0

func _step_3(delta : float):
	translation += global_transform.basis.z * delta * .1
	if t > rand_range(.0, 10.0):
		step = 2
		model.idle()
		t = .0

func _ready():
	model.fly()
	translation.y = 1
