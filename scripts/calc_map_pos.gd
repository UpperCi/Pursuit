tool
extends Node2D

export var snap = false setget set_snap

func set_snap(v):
	snap = false
	for c in get_children():
		c.start_pos = (c.position / 16).floor()
		c.position = c.start_pos * 16 + Vector2(8, 8)

func _process(delta):
	if Engine.editor_hint:
		set_snap(true)
