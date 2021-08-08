extends CPUParticles

func emit():
	restart()
	emitting = true

func _on_Timer_timeout():
	queue_free()
