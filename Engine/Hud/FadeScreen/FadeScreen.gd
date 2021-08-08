extends ColorRect

onready var tween := $Tween

func game_listener_on_summary_closed():
	tween.interpolate_property(self, "color:a",
			.0, 1.0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func game_listener_on_timed_out():
	tween.interpolate_property(self, "color:a",
			.0, 1.0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func game_listener_on_title_shown():
	tween.interpolate_property(self, "color:a",
			1.0, .0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func player_listener_on_dead(plyr):
	tween.interpolate_property(self, "color:a",
			.0, 1.0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func menu_listener_on_opened():
	tween.interpolate_property(self, "color:a",
			self.color.a, .0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func menu_listener_on_closed(data):
	tween.interpolate_property(self, "color:a",
			.0, 1.0, 1.0,
			Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func _enter_tree():
	color.a = 1.0
