extends Spatial

var keys_needed : int

onready var fliky_template = preload("res://Engine/GameObjects/Lifecicle/Flicky/Flicky.tscn")

onready var capsules = [$Capsule, $OpenedCapsule]

onready var keys_collected := 0
onready var completed := false

onready var shielded : bool = LevelLoadSharedData.player_shield > -1
onready var invincible : bool = false

func player_listener_on_monitor_destroyed(monitor : Monitor):
	match monitor.type:
		Monitor.MonitorType.INVINCIBLE: invincible = true
		Monitor.MonitorType.BASIC_SHIELD: shielded = true
		Monitor.MonitorType.SHIELD_1: shielded = true
		Monitor.MonitorType.SHIELD_2: shielded = true
		Monitor.MonitorType.SHIELD_3: shielded = true
		Monitor.MonitorType.SHIELD_4: shielded = true

func player_listener_on_shield_lost(plyr):
	shielded = false

func player_listener_on_key_catched(first_time : bool):
	keys_collected += 1
	_update_window()

func player_listener_on_player_damaged(plyr):
	if shielded or invincible: return
	keys_collected = 0
	_update_window()

func complete():
	completed = true
	capsules[0].hide()
	capsules[1].show()
	_explosions()

func _explosions():
	VfxEmitter.explosion(global_transform.origin + (Vector3.UP + Vector3.FORWARD))
	yield(get_tree(), "idle_frame")
	VfxEmitter.explosion(global_transform.origin + (Vector3.UP + Vector3.RIGHT))
	yield(get_tree(), "idle_frame")
	VfxEmitter.explosion(global_transform.origin + (Vector3.UP + Vector3.BACK))
	yield(get_tree(), "idle_frame")
	VfxEmitter.explosion(global_transform.origin + (Vector3.UP + Vector3.LEFT))
	yield(get_tree(), "idle_frame")
	_instance_flickies()

func _count_keys():
	keys_needed = get_tree().get_nodes_in_group("KEY").size()
	_update_window()

func _update_window():
	var mat : SpatialMaterial = $Capsule.mesh.surface_get_material(4)
	mat.uv1_offset.x = (keys_needed - keys_collected) * .1

func _instance_flickies():
	var incr := PI / 6.0
	var angle := incr * 7.5
	for i in range(10):
		var flicky = fliky_template.instance()
		add_child(flicky)
		flicky.rotation.y = angle + PI
#		flicky.translation = Vector3(sin(angle), .0, cos(angle))
		angle += incr

func _ready():
	call_deferred("_count_keys")
	capsules[1].hide()
