extends Player

class_name SonicPlayer

export(float) var speed := 2.0
export(float) var speed_per_ring := .1
export(float) var speed_per_ring_multiplier_by_ring_count := 20.0
export(float) var acceleration := 14.0
export(float) var air_control  := 2.0
export(float) var roll_control := 4.0
export(float) var jump_force   := 13.0
export(float) var jump_destroy_force := 9.0
export(float) var spindash_force := 4.0
export(float) var turn_speed = 5.0
export(float) var gravity = 30.0
export(float) var snap_floor = 50.0
export(float) var slope_impact = 1.0

onready var statemachine  := $Statemachine
onready var invincible_manager := $InvincibleManager
onready var shield_manager     := $ShieldManager
onready var glb           := $Glb
onready var vfx           := $Vfx
onready var center        := $Center
onready var impulse_point := $ImpulsePoint
onready var linear_velocity_area := $LinearVelocityArea
onready var speed_multiplier_area := $SpeedMultiplierArea
onready var slide_multiplier_area := $SlideMultiplierArea
onready var bounce_sensor         := $BounceSensor
onready var body_colllision_area  := $BodyCollisionArea

onready var floor_raycast_result : Dictionary
onready var velocity := Vector3.ZERO
onready var effective_speed := speed
onready var rings    := LevelLoadSharedData.rings_to_instantiate
onready var rolling  := false
onready var damaged  := false
onready var dead     := false
onready var teleport = null # Vector3
onready var impulsed = null # Vector3
onready var slope_strength := 1.0
onready var slope_effort_i : float = .0 # Indice que va incrementando cuestas arriba
onready var slope_effort : float   = 1.0 # Lo que cuesta subir una cuesta

# Shields
export(float)   var fire_shield_homing_speed : float = 8.0
export(Vector3) var bubble_shield_impulse : Vector3 = Vector3.DOWN * 7.5
export(float)   var bubble_shield_bounce_max_length : float = 14.0



#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Floor y solo floor
# [x][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Walls y solo walls
# [ ][x][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Water
# [ ][ ][x][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Player y solo player
# [ ][ ][ ][ ][x]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][x][ ][ ][ ]  Damage area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][x][ ][ ]  Body collision area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][x][ ]  Activation area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][x]  Linear velocity area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Slide multiplier area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][x][ ]
#
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][ ]  Speed multiplier area
# [ ][ ][ ][ ][ ]  [ ][ ][ ][ ][x]
#
#


func game_listener_on_goal_opened():
	# Paramos input
	set_process(false)
	statemachine.force(statemachine.win_state)

func game_listener_on_timed_out():
	# Paramos input
	set_process(false)
	statemachine.force(statemachine.timeout_state)

func player_listener_on_dead(plyr):
	# Paramos input
	set_process(false)
	statemachine.force(statemachine.death_state)

func player_listener_on_ring_catched():
	rings = clamp(rings + 1, 0, Constants.MAX_PLAYER_RINGS)
	_update_effective_speed()

func player_listener_on_enemy_destroyed(enmy):
	velocity.y = jump_destroy_force

func player_listener_on_monitor_destroyed(monitor):
	if statemachine.current_state == statemachine.bubble_drop_state:
		statemachine.force(statemachine.bubble_jump_state)
		velocity.y += jump_destroy_force * .25
	else:
		velocity.y = jump_destroy_force

func player_listener_on_player_damaged(plyr):
	if plyr == self:
		if invincible_manager.invincible: return
		if shield_manager.has_shield():
			get_tree().call_group("PLAYER_LISTENER", "player_listener_on_shield_lost", self)
			damaged = true
			return
		if EngineConfig.DEATH_ON_DAMAGE_WITH_NO_RINGS and rings < 1:
			get_tree().call_group("PLAYER_LISTENER", "player_listener_on_dead", self)
			dead = true
			return
		ItemsExplosion.emit_rings(global_transform.origin, rings)
		ItemsExplosion.emit_keys(global_transform.origin) # TODO Cambiar por .emit_custom_item(0, global_transform.origin))
		_update_rings_on_damage()
		_update_effective_speed()
		damaged = true

func _update_rings_on_damage():
	if EngineConfig.LOSS_ALL_RINGS_ON_DAMAGE:
		rings = 0
	else:
		rings = clamp(rings - Constants.MAX_PLAYER_LOSS_RINGS, 0.0, rings)

func _update_effective_speed():
	var incr : float = rings * (speed_per_ring / clamp(rings / speed_per_ring_multiplier_by_ring_count, 1, 20))
	effective_speed = clamp(speed + incr, .1, 10)

func _check_floor():
	var up_margin = glb.global_transform.basis.y * .5
	var down_margin = glb.global_transform.basis.y * .1
	floor_raycast_result = space_state.intersect_ray(
			global_transform.origin + up_margin,
			global_transform.origin - down_margin,
			[], 1024, true, false)
	if floor_raycast_result.size():
		_calc_slope_strength()

func _calc_slope_strength():
	var normal = floor_raycast_result.normal.normalized()
	var x = atan2(normal.z, sqrt(pow(normal.y, 2) + pow(normal.x, 2)))
	var y = .0
	var z = -atan2(normal.x, sqrt(pow(normal.y, 2) + pow(normal.z, 2)))
	var dir = -rotation.y
	var calc = \
			cos(dir + Constants.SEMI_PI) * (-z) \
			+ cos(dir) * x
	slope_strength = clamp(calc, -4.0, 4.0) * slope_impact + 1.0

func _physics_process(delta : float):
	_check_floor()
	statemachine.step(delta)

func _process(delta : float):
	update_analog_control(Vector2(
			Input.get_action_strength("dl") - Input.get_action_strength("dr"),
			Input.get_action_strength("du") - Input.get_action_strength("dd")))

func _ready():
	_update_effective_speed()
	get_tree().call_deferred("call_group",
			"PLAYER_LISTENER", "player_listener_on_prepared", self)
