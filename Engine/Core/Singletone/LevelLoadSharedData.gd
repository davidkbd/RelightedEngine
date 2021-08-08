extends Node

onready var level_to_load := ""
onready var rings_to_instantiate := 0
onready var bonus_time := .0
onready var player_shield := -1

const FILE := "user://loadshareddata_slot_{N}.data"
const PASS := "kdjskj348JHKDFkjdf:,df_"

var current_slot : int

func reset(slot_id : int = -1):
	if slot_id > 0:
		current_slot = slot_id

	level_to_load = Constants.DEFAULT_GAME_FOLDER + "Levels/" + Progress.get_next_level()
	rings_to_instantiate = 0
	bonus_time = 0
	player_shield = -1
	store_in_current_slot()

func load_slot(slot_id : int):
	current_slot = slot_id

	var storage : Storage = Storage.new(_get_file(), PASS)
	var result = storage.load_data()
	if result.result == OK:
		level_to_load = result.data.level_to_load
		rings_to_instantiate = result.data.rings_to_instantiate
		bonus_time = result.data.bonus_time
		player_shield = result.data.player_shield
		return
	reset()

func store_in_current_slot():
	var storage : Storage = Storage.new(_get_file(), PASS)
	return storage.store_data({
		"level_to_load": level_to_load,
		"rings_to_instantiate": rings_to_instantiate,
		"bonus_time": bonus_time,
		"player_shield" : player_shield
	})

func _get_file():
	return FILE.replace("{N}", str(current_slot))
