extends Control

export(Array, Resource) var rank_sprites : Array

onready var congratulations := $Congratulations
onready var zone_number_act := $ZoneAct
onready var rest_time := $RestTime
onready var elapsed_time := $ElapsedTime
onready var rings := $Rings
onready var score := $Score


var rank_times : Array

var rings_value : int
var rest_time_value : int
var elapsed_time_value : float
var score_value : int

func game_listener_on_summary_data_sent(summary_data : Dictionary):
	if summary_data.has("rings"):
		_update_rings(summary_data.rings)
	if summary_data.has("rest_time"):
		_update_rest_time(summary_data.rest_time)
	if summary_data.has("elapsed_time"):
		_update_elapsed_time(summary_data.elapsed_time)
	if summary_data.has("score"):
		_update_score(summary_data.score)

func game_listener_on_loaded(data : Dictionary):
	congratulations.text = tr("summary.congratulations") + "!"
	zone_number_act.text = data.zone + "-" + data.act + " " + tr("summary.clear") + "!!"
	rank_times = data.times

func game_listener_on_goal_opened():
	$AnimationPlayer.play("show")

func done():
	get_tree().call_group("GAME_LISTENER", "game_listener_on_summary_closed")
	$AnimationPlayer.stop()
	set_process(false)

func _update_rings(n : int):
	rings_value = n
	rings.text = tr("summary.rings") + ": " + str(n)

func _update_rest_time(n : int):
	rest_time_value = n
	rest_time.text = tr("summary.rest_time") + ": " + TextFormat.timestamp(n)


func _update_elapsed_time(n : float):
	elapsed_time_value = n
	elapsed_time.text = tr("summary.elapsed_time") + ": " + TextFormat.timestamp_float(n)

func _update_rank(n : int):
	$ElapsedTime/Rank.texture = rank_sprites[n]

func _update_score(n : int):
	score_value = n
	score.text = tr("summary.score") + ": " + str(n)
	get_tree().call_group("PLAYER_LISTENER", "player_listener_on_score_updated", n)

func _rings_to_score():
	$Tween.interpolate_method(self, "_update_rings", rings_value, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_method(self, "_update_score", score_value, score_value + rings_value *  Constants.BONUS_PER_RING, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _rank():
	var rank : int
	if elapsed_time_value < rank_times[0]: rank = 0
	elif elapsed_time_value < rank_times[1]: rank = 1
	elif elapsed_time_value < rank_times[2]: rank = 2
	elif elapsed_time_value < rank_times[3]: rank = 3
	elif elapsed_time_value < rank_times[4]: rank = 4
	else: rank = 5
	$Tween.interpolate_method(self, "_update_rank", 5, rank, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func _rank_to_score():
	if elapsed_time_value < rank_times[0]:
		$Tween.interpolate_method(self, "_update_score", score_value, score_value + Constants.BONUS_PER_RANK_S, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func _process(delta : float):
	if Input.is_action_pressed("jump"):
		done()

func _ready():
	set_process(false)

func _enter_tree():
	hide()
