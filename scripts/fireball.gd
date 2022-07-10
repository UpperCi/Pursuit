extends "res://scripts/effect.gd"

onready var tween = $Tween
onready var parts = $CPUParticles2D

func _ready():
	position = start_pos * 16 + Vector2(8, 8)
	var diff = end_pos - start_pos
	position += diff.normalized() * 4
	var rot = Vector2.UP.angle_to(diff.normalized())
	rotation = rot
	parts.position = Vector2(0, -8)
	anim.play("Play")
	tween.interpolate_property(self, "position",
		position, end_pos * 16 + Vector2(8, 8) - diff.normalized() * 8,
		0.075 * diff.length(), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	anim.play("Explode")
