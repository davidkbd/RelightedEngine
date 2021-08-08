extends Node

onready var DEFAULT_SETTINGS : Dictionary = {
	"sound": {
		"music_volume": .9,
		"sfx_volume": .9
	},
	"graphics": {
		# 0 low
		# 1 med
		# 2 hi
		"level": 2
	},
	"inputs": {
		"Q":     _create_data_key(16777217),
		"du":    _create_data_key(16777232),
		"dd":    _create_data_key(16777234),
		"dl":    _create_data_key(16777231),
		"dr":    _create_data_key(16777233),
		"jump":  _create_data_key(88),
		"spin":  _create_data_key(90)
	}
}
onready var settings : Dictionary

const PASS : String = "akjdflkj3kjskdjfjslslskdjfkjf77:"
const SETTINGS_FILE  : String = "user://settings.data"

func load_settings():
	var storage : Storage = Storage.new(SETTINGS_FILE, PASS)
	var result = storage.load_data()
	if result.result == OK:
		settings = result.data
		_apply()
		return
	print("Not settings data found. Default settings loaded")
	settings = DEFAULT_SETTINGS.duplicate(true)
	_apply()

func save_settings():
	var storage : Storage = Storage.new(SETTINGS_FILE, PASS)
	return storage.store_data(settings)
	_apply()

func _apply():
	get_tree().call_group("SETTINGS_LISTENER", "settings_listener_on_applied", settings)

func _create_data_key(code1):
	return { "type": "InputEventKey", "code1": code1, "code2": ""}

func _ready():
	load_settings()
