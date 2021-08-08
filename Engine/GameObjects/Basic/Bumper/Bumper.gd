extends Area

export(float) var strength = 30.0
export(Vector3) var anim_size := Vector3(1.2, 1.0, 1.2)

onready var tween := $Tween
onready var model := $Model

func collided(activator):
	if activator is Player:
		var dif_position = (activator.impulse_point.global_transform.origin - global_transform.origin).normalized() * strength
		activator.velocity += dif_position
		tween.stop_all()
		tween.resume_all()
		tween.interpolate_property(model, "scale",
				anim_size, Vector3.ONE, .5,
				Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()
