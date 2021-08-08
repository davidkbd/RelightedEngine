extends Spatial

onready var damage_hilight_material : ShaderMaterial = preload("res://Engine/BaiscMaterial/PlayerHilight.material")

onready var restore_timer := $RestoreTimer
onready var tree := $AnimationTree
onready var playback : AnimationNodeStateMachinePlayback = tree.get("parameters/playback")

func player_listener_on_player_damaged(plyr):
	if plyr == get_parent():
		if plyr.invincible_manager.invincible: return
		restore_timer.start()
		damage_hilight_material.set_shader_param("blink", true)
		set_process(true)

func idle():
	playback.travel("Idle")

func run():
	playback.travel("Run")

func fall_down():
	playback.travel("FallDown")

func fall_up():
	playback.start("FallUp")

func damage():
	playback.start("Damage")

func jump():
	playback.start("Jump")

func spin():
	playback.start("Spin")

func run_speed(value : float):
	tree.set("parameters/Run/TimeScale/scale", value)

func spin_speed(value : float):
	tree.set("parameters/Spin/TimeScale/scale", value)

func _on_RestoreTimer_timeout():
	damage_hilight_material.set_shader_param("blink", false)

func _ready():
	restore_timer.wait_time = Constants.INVINCIBLE_POST_DAMAGE_TIME
