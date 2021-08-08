extends MenuScreen

onready var status : = false

func game_listener_on_paused(paused : bool):
	get_tree().paused = paused
	if paused:
		start()
	else:
		stop()

func menu_listener_on_pause_continue():
	status = false
	get_tree().call_group("GAME_LISTENER", "game_listener_on_paused", status)

func menu_listener_on_pause_quit():
	get_tree().paused = false
	get_tree().change_scene(Constants.START_MENU_SCENE)

func start():
	$AnimationPlayer.play("start")
	.start()

func stop():
	$AnimationPlayer.play("stop")

func _animation_end_stop():
	.stop()

func initialize_options():
	options = [ $Options/Continue, $Options/Quit ]

func _input(event : InputEvent):
	if event.is_action_pressed("Q"):
		status = !status
		get_tree().call_group("GAME_LISTENER", "game_listener_on_paused", status)

func _ready():
	hide()
