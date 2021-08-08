extends CPUParticles

func emit():
	emitting = true
	$FireParticles.emitting = true

func _on_Tween_tween_all_completed():
	queue_free()

func _ready():
	var tween : Tween = $Tween
	var light : OmniLight = $OmniLight
	tween.interpolate_property(light, "light_energy",
			3.0, .0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
