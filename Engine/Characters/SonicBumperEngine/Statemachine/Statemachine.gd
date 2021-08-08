extends Node

onready var idle_state := $IdleState
onready var walk_state := $WalkState
onready var jump_state := $JumpState
onready var fall_state := $FallState
onready var roll_state := $RollState
onready var spindash_state := $SpindashState
onready var damage_state   := $DamageState
onready var teleport_state := $TeleportState
onready var win_state      := $WinState
onready var timeout_state  := $TimeoutState

onready var current_state := idle_state
onready var previous_state := current_state

func force(new_state):
	previous_state = current_state
	current_state = new_state
	previous_state.exit()
	current_state.enter()

func step(delta : float):
	var next = current_state.step(delta)
	if next != current_state:
		force(next)
