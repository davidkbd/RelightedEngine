extends Node

onready var _stream_players : Array = _create_stream_players()
onready var _fade_tween     : Tween = _create_fade_tween()

func play(stream_file : String, fade_duration : float = 1.0):
	if _fade_tween.is_active():
		_fade_tween.remove_all()
		_on_cross_fade_completed()
	_stream_players[0].volume_db = -80.0
	_fade_tween.interpolate_property(
			_stream_players[0], "volume_db",
			-80.0, .0, fade_duration,
			Tween.TRANS_QUINT, Tween.EASE_OUT)
	_fade_tween.interpolate_property(
			_stream_players[1], "volume_db",
			.0, -80.0, fade_duration,
			Tween.TRANS_SINE, Tween.EASE_IN)
	_fade_tween.start()
	if stream_file == "": return
	var stream = load(stream_file)
	if stream == null:
		print("ERROR, musica no encontrada ", stream_file)
		return
	_stream_players[0].stream = stream
	_stream_players[0].play()

func stop(fade_duration : float):
	play("", fade_duration)

func _on_cross_fade_completed():
	_stream_players.invert()
	if _stream_players[0].playing:
		_stream_players[0].stop()

func _create_stream_players() -> Array:
	var r = []
	r.append(AudioStreamPlayer.new())
	r.append(AudioStreamPlayer.new())
	for a in r:
		add_child(a)
		a.bus = "Music"
		a.volume_db = -80.0
	return r

func _create_fade_tween() -> Tween:
	var r = Tween.new()
	add_child(r)
	r.connect("tween_all_completed", self, "_on_cross_fade_completed")
	return r
