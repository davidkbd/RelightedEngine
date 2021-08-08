extends MenuScreen

onready var value_indicators := [ $Options/MusicValueIndicator, $Options/SfxValueIndicator ]

func start():
	$AnimationPlayer.play("start")
	.start()

func stop():
	$AnimationPlayer.play("stop")

func _animation_end_stop():
	.stop()

func menu_listener_on_settings_popup_closed(value):
	if value:
		_save_settings()
	else:
		_restore_settings()
	
func initialize_options():
	options = [
			$Options/InputMap,
			$Options/MusicVolume,
			$Options/SfxVolume,
			$Options/Back
			]

func _process(delta : float):
	if selected_option > 0 and selected_option < 3:
		if Input.is_action_just_pressed("ui_left"):
			_update_volume(selected_option, value_indicators[selected_option - 1], -.1)
		elif Input.is_action_just_pressed("ui_right"):
			_update_volume(selected_option, value_indicators[selected_option - 1], .1)

func _update_volume(bus : int, indicator : ValueIndicator, incr : float):
	var vol = db2linear(AudioServer.get_bus_volume_db(bus))
	vol = clamp(vol + incr, .0, 1.0)
	indicator.set_value(vol)
	AudioServer.set_bus_volume_db(bus, linear2db(vol))
	AudioServer.set_bus_mute(bus, vol < .1)

func _update_values():
	var bus := 1
	for indicator in value_indicators:
		indicator.set_value(db2linear(AudioServer.get_bus_volume_db(bus)))
		bus += 1

func _save_settings():
	Settings.settings.sound.music_volume = value_indicators[0].value
	Settings.settings.sound.sfx_volume = value_indicators[1].value
	Settings.save_settings()

func _restore_settings():
	Settings.load_settings()

func _any_button_pressed():
	.set_process(false)

func _ready():
	call_deferred("_update_values")
#
#func _enter_tree():
#	get_tree().call_group("MENU_LISTENER", "menu_listener_on_options_opened")
