extends Area

func activate(player):
	collided(player)

func deactivate(player):
	pass

func collided(player):
	if player.shield_manager.shield_type == 1:
		var tween = $ExplossionTween
		if tween.is_active(): return
		tween.interpolate_property(
				get_parent(), "scale:x",
				1.0, .9, .25,
				Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.interpolate_property(
				get_parent(), "scale:z",
				1.0, .9, .25,
				Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.start()

func _on_ExplossionTween_tween_all_completed():
	VfxEmitter.mini_explosion(global_transform.origin)
	get_parent().queue_free()

func _ready():
	call_deferred("deactivate", null)
