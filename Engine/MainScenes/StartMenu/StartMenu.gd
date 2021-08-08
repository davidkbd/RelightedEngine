extends Control

onready var current_screen = $TitleScreen

func menu_listener_on_new_game_created(slot_id : int):
	Progress.load_slot(slot_id)
	Progress.unlock_zone_act(1, 1)
	LevelLoadSharedData.load_slot(slot_id)
	_close($PrincipalScreen)
	get_tree().call_group("MENU_LISTENER", "menu_listener_on_closed", "")
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().change_scene(Constants.MENU_LEVEL_SELECTOR_SCENE)

func menu_listener_on_slot_selected_to_removed(slot_id : int):
	$DeleteSlotPopup.value = slot_id
	_open_popup($DeleteSlotPopup)

func menu_listener_on_slots_poup_closed(value):
	_close_popup($DeleteSlotPopup)

func menu_listener_on_slots_opened():
	_open($Slots)

func menu_listener_on_principal_opened():
	_open($PrincipalScreen)

func menu_listener_on_title_opened():
	_open($TitleScreen)

func menu_listener_on_options_opened():
	_open($OptionsScreen)

func menu_listener_on_inputmap_opened():
	_open($InputMapScreen)

func menu_listener_on_input_jump_pressed():
	_open_popup($InputMapJumpPopup)

func menu_listener_on_input_spindash_pressed():
	_open_popup($InputMapSpinPopup)

func menu_listener_on_input_jump_entered(value):
	_close_popup($InputMapJumpPopup)

func menu_listener_on_input_spindash_entered(value):
	_close_popup($InputMapSpinPopup)

func menu_listener_on_options_closed():
	_open_popup($SettingsClosePopup)

func menu_listener_on_settings_popup_closed(value):
	_close_popup($SettingsClosePopup)
	_open($PrincipalScreen)

func menu_listener_on_credits_opened():
	_open($CreditsScreen)

func menu_listener_on_credits_closed():
	_open($PrincipalScreen)

func menu_listener_on_quit():
	_open_popup($ExitPopup)
	
func menu_listener_on_exit_popup_closed(value):
	if value:
		get_tree().quit()
	else:
		_close_popup($ExitPopup)

func settings_listener_on_applied(settings : Dictionary):
	AudioServer.set_bus_volume_db(1, linear2db(MathFunctions.round_1_decimal(settings.sound.music_volume)))
	AudioServer.set_bus_volume_db(2, linear2db(MathFunctions.round_1_decimal(settings.sound.sfx_volume)))

func _open(screen : MenuScreen):
	_close(current_screen)
	current_screen = screen
	current_screen.start()

func _close(screen : MenuScreen):
	current_screen.stop()

func _open_popup(popup : MenuPopup):
	popup.start()
	current_screen.pause()

func _close_popup(popup : MenuPopup):
	popup.stop()
	current_screen.resume()

func _instance_controllers():
	for controller in [
		EngineConfig.MENU_BACKGROUND_CONTROLLER,
		EngineConfig.MENU_MUSIC_CONTROLLER]:
		add_child_below_node(
				$ControllersPosition,
				load(controller).instance())

func _ready():
	get_tree().call_deferred(
			"call_group",
			"MENU_LISTENER",
			"menu_listener_on_opened")
	call_deferred("_open", current_screen)
	_instance_controllers()

