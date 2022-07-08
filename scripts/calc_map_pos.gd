tool
extends Node2D

export var snap = false setget set_snap

func set_snap(v):
	snap = false
	for c in get_children():
		c.start_pos = (c.position / 16).floor()
		c.position = c.start_pos * 16

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		set_snap(true)
