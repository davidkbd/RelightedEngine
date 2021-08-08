extends StaticBody

onready var area := $DamageArea
onready var tween := $Tween

func toggle_trap_listener_on_activate():
	tween.stop_all()
	tween.resume_all()
	tween.interpolate_property(area, "translation:y",
			area.translation.y, .0, 1.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	area.enable()
	tween.start()

func toggle_trap_listener_on_deactivate():
	tween.stop_all()
	tween.resume_all()
	tween.interpolate_property(area, "translation:y",
			area.translation.y, -.5, 1.0,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
