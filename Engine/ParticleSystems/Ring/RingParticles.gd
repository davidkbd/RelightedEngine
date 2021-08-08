extends CPUParticles

func emit():
	emitting = true

func _on_Timer_timeout():
	queue_free()
