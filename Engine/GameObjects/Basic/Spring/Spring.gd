extends Area

export(float) var strength := 20.0
export(bool)  var shadow    := true

func activate(activator):
	$Glb/AnimationPlayer.play("Action")
	activator.impulsed = global_transform.basis.y * strength
#	set_collision_mask_bit(8, false)

func deactivate(activator):
	pass

func _ready():
	if not shadow:
		$Shadow.hide()
