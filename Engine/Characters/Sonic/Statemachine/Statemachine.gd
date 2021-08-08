extends Node

onready var idle_state := $IdleState
onready var walk_state := $WalkState
onready var jump_state := $NormalJumpState
onready var fire_homing_state := $FireHommingState
onready var bubble_drop_state := $BubbleDropState
onready var fall_state := $NormalFallState
onready var roll_state := $RollState
onready var spindash_state := $SpindashState
onready var damage_state   := $DamageState
onready var teleport_state := $TeleportState
onready var win_state      := $WinState
onready var timeout_state  := $TimeoutState
onready var death_state    := $DeathState

# Shield-Jumps
onready var normal_jump_state := $NormalJumpState
onready var fire_jump_state := $FireJumpState
onready var electric_jump_state := $ElectricJumpState
onready var bubble_jump_state := $BubbleJumpState
# Shield-Falls
onready var normal_fall_state := $NormalFallState
onready var fire_fall_state := $FireFallState
onready var electric_fall_state := $ElectricFallState
onready var bubble_fall_state := $BubbleFallState

onready var current_state := idle_state
onready var previous_state := current_state

func set_shield(shield_type : int):
	_update_state_links(shield_type)
	_update_current_state(shield_type)

func force(new_state):
	_change_state(new_state)
	
func step(delta : float):
	var next = current_state.step(delta)
	if next != current_state:
		_change_state(next)

func _change_state(new_state):
	previous_state = current_state
	current_state = new_state
	previous_state.exit()
	current_state.enter()

func _update_state_links(shield_type : int):
	if shield_type < 1 or shield_type > 3:
		jump_state = normal_jump_state
		fall_state = normal_fall_state
	else:
		match shield_type:
			1:
				jump_state = fire_jump_state
				fall_state = fire_fall_state
			2:
				jump_state = electric_jump_state
				fall_state = electric_fall_state
			3:
				jump_state = bubble_jump_state
				fall_state = bubble_fall_state

func _update_current_state(shield_type : int):
	match current_state:
		# JUMP
		normal_jump_state: current_state = jump_state
		fire_jump_state: current_state = jump_state
		electric_jump_state: current_state = jump_state
		bubble_jump_state: current_state = jump_state
		# FALL
		normal_fall_state: current_state = jump_state
		fire_fall_state: current_state = jump_state
		electric_fall_state: current_state = jump_state
		bubble_fall_state: current_state = jump_state
