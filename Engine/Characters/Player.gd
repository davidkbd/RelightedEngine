extends KinematicBody

class_name Player

onready var space_state : PhysicsDirectSpaceState = get_world().direct_space_state

onready var analog_control_value : Vector2 = Vector2.ZERO
onready var analog_control_normalized : Vector2 = Vector2.ZERO
onready var analog_control_length : float = .0
onready var analog_control_angle : float = .0

var camera_rotation

func camera_listener_on_rotated(new_camera_rotation : float):
	camera_rotation = new_camera_rotation

func update_analog_control(dir : Vector2):
	analog_control_value = dir
	analog_control_length = analog_control_value.length()
	analog_control_normalized = analog_control_value.normalized()
	analog_control_angle = analog_control_value.angle()
