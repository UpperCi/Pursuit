extends "res://scripts/effect.gd"

func _ready():
	position = end_pos * 16 + Vector2(8, 8)
	anim.play("Play")
