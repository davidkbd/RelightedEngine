extends Node

var DEFAULT_DATA : Dictionary = {
		"empty": true,
		"accumulated_time": .0,
		"score": 0,
		"lifes": 3,
		"unlocked_acts": []
}

const FILE := "user://game_slot_{N}.data"
const PASS := "kdjskj348JHKDFkjdf:,df_"

var current_slot : int
var data : Dictionary

func reset(slot_id : int = -1):
	if slot_id > 0:
		current_slot = slot_id
	data = DEFAULT_DATA.duplicate(true)
	store_in_current_slot()

func load_slot(slot_id : int):
	current_slot = slot_id
	var storage : Storage = Storage.new(_get_file(), PASS)
	var result = storage.load_data()
	if result.result == OK:
		data = result.data
		if not data.has("unlocked_acts"):
			data.unlocked_acts = []
		data.empty = false
		return
	reset()

func store_in_current_slot():
	var storage : Storage = Storage.new(_get_file(), PASS)
	return storage.store_data(data)

func is_slot_empty(slot_id : int):
	var storage : Storage = Storage.new(_get_file(slot_id), PASS)
	var result = storage.load_data()
	if result.result == OK:
		if result.data.has("empty") and result.data.empty:
			return true
		else:
			return false
	return true

func unlock_zone_act(zone_id : int, act_id : int):
	for act in data.unlocked_acts:
		if act.zone == zone_id and act.act == act_id:
			return
	data.unlocked_acts.append({"zone": zone_id, "act": act_id})

func get_next_level() -> String:
	var zone = _get_max_zone()
	var act = _get_max_act_of_zone(zone)
	var file : String = "%02d-%02d/%02d-%02d.tscn" % [zone, act, zone, act]
	return file

func _get_file(slot_id : int = -1):
	var n = slot_id if slot_id > 0 else current_slot
	return FILE.replace("{N}", str(n))

func _get_max_zone():
	var r : int = 1
	for act in data.unlocked_acts:
		if act.zone > r: r = act.zone
	return r

func _get_max_act_of_zone(zone_id : int):
	var r : int = 1
	for act in data.unlocked_acts:
		if act.zone == zone_id:
			if act.act > r: r = act.act
	return r
