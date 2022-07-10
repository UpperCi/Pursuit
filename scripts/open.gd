extends "res://scripts/effect.gd"

onready var parts = $CPUParticles2D

func _ready():
	position = end_pos * 16 + Vector2(8, 8)
	anim.play("Play")
	parts.emitting = true
