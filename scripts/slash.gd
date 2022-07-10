extends "res://scripts/effect.gd"

onready var parts = $CPUParticles2D

func _ready():
	position = end_pos * 16 + Vector2(8, 8)
	var diff = end_pos - start_pos
	position -= diff.normalized() * 4
	var rot = Vector2.UP.angle_to(diff.normalized())
	rotation = rot
	anim.play("Play")
	parts.position = Vector2(0, -4)
	parts.emitting = true
