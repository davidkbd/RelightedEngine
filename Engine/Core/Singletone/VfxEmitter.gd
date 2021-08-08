extends Node

onready var explosion_particles = preload("res://Engine/ParticleSystems/Explosion/ExplosionParticles.tscn")
onready var mini_explosion_particles = preload("res://Engine/ParticleSystems/Explosion/MiniExplosionParticles.tscn")
onready var ring_particles = preload("res://Engine/ParticleSystems/Ring/RingParticles.tscn")
onready var water_splash_particles = preload("res://Engine/ParticleSystems/WaterSplash/WaterSplashParticles.tscn")

func explosion(position : Vector3):
	var inst = explosion_particles.instance()
	add_child(inst)
	inst.global_transform.origin = position
	inst.emit()

func mini_explosion(position : Vector3):
	var inst = mini_explosion_particles.instance()
	add_child(inst)
	inst.global_transform.origin = position
	inst.emit()

func ring(position : Vector3):
	var inst = ring_particles.instance()
	add_child(inst)
	inst.global_transform.origin = position
	inst.emitting = true

func water_splash(position : Vector3, speed : float):
	var inst = water_splash_particles.instance()
	add_child(inst)
	inst.initial_velocity *= speed
	inst.global_transform.origin = position
	inst.emitting = true
