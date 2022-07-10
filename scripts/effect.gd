extends Node2D
# measured in tiles
export var start_pos = Vector2.ZERO
export var end_pos = Vector2.ZERO
export (Array, Vector2) var hits = []

onready var anim = $AnimationPlayer

func end():
	queue_free()
