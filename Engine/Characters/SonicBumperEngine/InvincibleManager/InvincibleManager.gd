extends Timer

onready var invincible : bool = false

func player_listener_on_monitor_destroyed(monitor : Monitor):
	match monitor.type:
		Monitor.MonitorType.INVINCIBLE:
			invincible = true
			start()

func _on_InvincibleTimer_timeout():
	invincible = false

func _ready():
	wait_time = Constants.INVINCIBLE_POWERUP_TIME
