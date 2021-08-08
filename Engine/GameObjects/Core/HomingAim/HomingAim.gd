extends Spatial

onready var tween := $Tween

onready var target : Spatial = null

func follow(new_target : Spatial):
	target = new_target
	.show()
	set_physics_process(true)
	scale = Vector3.ZERO
	tween.stop_all()
	tween.resume_all()
	tween.interpolate_property(self, "scale",
			scale, Vector3.ONE, .5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func hide():
	tween.stop_all()
#	tween.resume_all()
	tween.interpolate_property(self, "scale",
			scale, Vector3.ZERO, .25,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	if scale.x < .1:
		.hide()
		set_physics_process(false)

func _physics_process(delta : float):
	if is_instance_valid(target):
		global_transform.origin = target.global_transform.origin + Vector3.UP * .1 
	else:
		set_physics_process(false)
		hide()

func _ready():
	.hide()
	set_physics_process(false)
