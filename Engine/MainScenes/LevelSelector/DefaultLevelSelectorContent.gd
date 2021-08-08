extends Control

signal level_opened(id)
signal back

onready var level_buttons := $ScrollContainer/LevelButtons

func menu_listener_on_closed(level_id):
	for button in level_buttons.get_children():
		button.disabled = true
	$BackButton.disabled = true

func _on_level_opened(id):
	emit_signal("level_opened", id)

func show_levels():
	for zone in EngineConfig.MENU_LEVEL_SELECTOR_LEVELS:
		for act in zone.acts:
			if get_parent().is_level_unlocked(zone.zone_id, act):
				var id = zone.zone_id + "-" + act
				var button = Button.new()
				button.text = id
				button.connect("pressed", self, "_on_level_opened", [id])
				level_buttons.add_child(button)
	level_buttons.get_child(0).grab_focus()

func _on_BackButton_pressed():
	emit_signal("back")
