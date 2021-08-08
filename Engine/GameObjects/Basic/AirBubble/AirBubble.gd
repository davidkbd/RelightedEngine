extends Area

export(float) var explode_y_position : float = .0
export(float) var speed              : float = .09

onready var life_tween := $LifeTween
onready var radius = $CSGSphere.radius

func _on_AirBubble_area_entered(area):
	get_tree().call_group(
			"PLAYER_LISTENER",
			"player_listener_on_underwater_breathed",
			area.get_parent())
	queue_free()

func _process(delta : float):
	global_transform.origin.y += delta * speed
	if global_transform.origin.y + radius > explode_y_position:
		queue_free()

func _on_LifeTween_tween_all_completed():
	life_tween.queue_free()

func _ready():
	life_tween.interpolate_property(self, "scale",
			Vector3.ZERO, Vector3.ONE, 1.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	life_tween.start()
