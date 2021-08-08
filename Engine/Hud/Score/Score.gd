extends HBoxContainer

onready var score_label := $Score

var score : int

func player_listener_on_enemy_destroyed(enemy):
	increment(Constants.PLAYER_ENEMY_SCORE)

func player_listener_on_score_updated(new_score):
	force(new_score)

func game_listener_on_goal_opened():
	get_tree().call_deferred(
			"call_group",
			"GAME_LISTENER",
			"game_listener_on_summary_data_sent",
			{ "score": score })

func force(n : int):
	score = clamp(n, 0, Constants.MAX_SCORE)
	_update_score()

func increment(n : int):
	score = clamp(score + n, 0, Constants.MAX_SCORE)
	_update_score()

func _update_score():
	score_label.text = str(score)

func _initialize_values():
	if Progress.data.size() == 0: return
	score = Progress.data.score

func _ready():
	_initialize_values()
	_update_score()
