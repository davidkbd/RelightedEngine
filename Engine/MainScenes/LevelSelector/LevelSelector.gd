extends Node

export(PackedScene) var fadescreen_template : PackedScene

# For using in Content
func is_level_unlocked(zone, act) -> bool:
	for level in Progress.data.unlocked_acts:
		var zone_id = "%02d" % level.zone
		var act_id  = "%02d" % level.act
		if zone_id == zone and act_id == act:
			return true
	return false

func _on_level_opened(level_id : String):
	get_tree().call_group("MENU_LISTENER", "menu_listener_on_closed", level_id)
	if EngineConfig.MENU_LEVEL_SELECTOR_RESET_RINGS_ON_OPEN:
		LevelLoadSharedData.rings_to_instantiate = 0
	if EngineConfig.MENU_LEVEL_SELECTOR_RESET_SHIELD_ON_OPEN:
		LevelLoadSharedData.player_shield = -1
	LevelLoadSharedData.level_to_load = "res://Game/Levels/%s/%s.tscn" % [level_id, level_id]
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene(Constants.INGAME_SCENE)

func _on_back_pressed():
	get_tree().call_group("MENU_LISTENER", "menu_listener_on_closed", "")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene(Constants.START_MENU_SCENE)

func _instane_content():
	var content = load(EngineConfig.MENU_LEVEL_SELECTOR_CONTENT_SCENE).instance()
	add_child(content)
	content.connect("level_opened", self, "_on_level_opened")
	content.connect("back", self, "_on_back_pressed")
	content.show_levels()

func _instance_fadescreen():
	var content = fadescreen_template.instance()
	$CanvasLayer.add_child(content)

func _ready():
	_instane_content()
	_instance_fadescreen()
	get_tree().call_group("MENU_LISTENER", "menu_listener_on_opened")
