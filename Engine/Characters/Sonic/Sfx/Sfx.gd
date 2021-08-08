extends Spatial

onready var shield_light := $ShieldLight
onready var shields := [
		$BasicShield,
		$FireShield,
		$ElectricShield,
		$BubbleShield,
		$IceShield
		]
onready var shield_colors := [
	Color.blue,
	Color.orange,
	Color.purple,
	Color.cyan,
	Color.aquamarine
]

onready var particles_fire_homing : CPUParticles = $FireShield/CPUParticles
onready var particles_electric_impulse : CPUParticles = $ElectricShield/CPUParticles
onready var tween_bubble_impulse : Tween = $BubbleShield/Tween

func set_shield(shield_type : int):
	var i := 0
	for shield in shields:
		shield.visible = i == shield_type
		i += 1
	if shield_type == -1:
		shield_light.hide()
	else:
		shield_light.show()
		shield_light.light_color = shield_colors[shield_type] 

func fire_shield_homing_begin():
	particles_fire_homing.emitting = true

func fire_shield_homing_end():
	particles_fire_homing.emitting = false

func electric_shield_impulse():
	particles_electric_impulse.restart()
	particles_electric_impulse.emitting = true

func bubble_shield_impulse():
	tween_bubble_impulse.stop_all()
	tween_bubble_impulse.resume_all()
	tween_bubble_impulse.interpolate_property(
			shields[3].get_active_material(0), "shader_param/deform",
			Vector3(.7, 1.2, .7), Vector3.ONE, 1.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween_bubble_impulse.start()

func bubble_shield_bounce():
	tween_bubble_impulse.stop_all()
	tween_bubble_impulse.resume_all()
	tween_bubble_impulse.interpolate_property(
			shields[3].get_active_material(0), "shader_param/deform",
			Vector3(1.3, .9, 1.3), Vector3.ONE, 2.5,
			Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween_bubble_impulse.start()
