extends "res://scripts/effect.gd"

onready var tween = $Tween

func _ready():
	position = start_pos * 16 + Vector2(8, 8)
	var diff = end_pos - start_pos
	position += diff.normalized() * 4
	anim.play("Play")
	$CPUParticles2D.position = Vector2(0, -8)
	tween.interpolate_property(self, "position",
		position, end_pos * 16 + Vector2(8, 8) - diff.normalized() * 2,
		0.1 * diff.length(), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	anim.play("Explode")
