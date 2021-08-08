extends Node

export(NodePath) var target

onready var ring_template = preload("res://Engine/GameObjects/Basic/Ring/Ring.tscn")

var rank_times : Array
var is_boss    : bool
var next_zone  : int
var next_act   : int

var rings_value : int
var rest_time_value : int
var elapsed_time_value : float
var score_value : int
var lifes_value : int
var player_shield_value : int

func game_listener_on_summary_data_sent(summary_data : Dictionary):
	if summary_data.has("rings"): rings_value = summary_data.rings
	if summary_data.has("rest_time"): rest_time_value = summary_data.rest_time
	if summary_data.has("elapsed_time"): elapsed_time_value = summary_data.elapsed_time
	if summary_data.has("score"): score_value = summary_data.score
	if summary_data.has("lifes"): lifes_value = summary_data.lifes
	if summary_data.has("player_shield"): player_shield_value = summary_data.player_shield

func game_listener_on_timeout_data_sent(timeout_data : Dictionary):
	if timeout_data.has("lifes"): lifes_value = timeout_data.lifes

func game_listener_on_summary_closed():
	yield(get_tree().create_timer(2.0), "timeout")
	_update_progress()
	if is_boss:
		_go_to_completed()
	else:
		_go_to_next()

func _update_progress():
	Progress.data.accumulated_time += elapsed_time_value
	Progress.data.score = score_value \
			+ rings_value * Constants.BONUS_PER_RING
	if elapsed_time_value < rank_times[0]:
		Progress.data.score += Constants.BONUS_PER_RANK_S
	Progress.data.lifes = lifes_value
	Progress.unlock_zone_act(next_zone, next_act)
	Progress.store_in_current_slot()

func _go_to_completed():
	get_tree().change_scene(Constants.ZONE_COMPLETED_SCENE)

func _go_to_next():
	var next_level : String = "%02d-%02d/%02d-%02d.tscn" % [next_zone, next_act, next_zone, next_act]
	print("Going to ", next_level)
	LevelLoadSharedData.level_to_load = Constants.DEFAULT_GAME_FOLDER + "Levels/" + next_level
	LevelLoadSharedData.rings_to_instantiate = rings_value
	LevelLoadSharedData.player_shield = player_shield_value
	LevelLoadSharedData.store_in_current_slot()
	if EngineConfig.MENU_LEVEL_SELECTOR_ON_LEVEL_COMPLETED:
		get_tree().change_scene(EngineConfig.MENU_LEVEL_SELECTOR_SCENE)
	else:
		get_tree().reload_current_scene()

func game_listener_on_timed_out():
	yield(get_tree().create_timer(2.0), "timeout")
	Progress.data.lifes = lifes_value
	LevelLoadSharedData.rings_to_instantiate = 0
	LevelLoadSharedData.player_shield = -1
	if lifes_value <= 0:
		get_tree().change_scene(Constants.GAME_OVER_SCENE)
	else:
		get_tree().reload_current_scene()

func player_listener_on_dead(plyr):
	yield(get_tree().create_timer(2.0), "timeout")
	Progress.data.lifes = lifes_value
	LevelLoadSharedData.rings_to_instantiate = 0
	LevelLoadSharedData.player_shield = -1
	if lifes_value <= 0:
		get_tree().change_scene(Constants.GAME_OVER_SCENE)
	else:
		get_tree().reload_current_scene()

func game_listener_on_loaded(data : Dictionary):
	rank_times = data.times
	is_boss    = data.is_boss
	next_zone  = data.next_zone
	next_act   = data.next_act

func player_listener_on_prepared(plyr):
	_instance_rings()

func _get_level_path():
	return LevelLoadSharedData.level_to_load

func _instance_level():
	var level = load(_get_level_path()).instance()
	get_node(target).add_child(level)

func _instance_rings():
	for ring_i in LevelLoadSharedData.rings_to_instantiate:
		var ring = ring_template.instance()
		get_node(target).add_child(ring)
		ring.mark_catched()

func _ready():
	call_deferred("_instance_level")
