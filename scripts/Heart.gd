extends "res://scripts/item.gd"

func _ready():
	$AnimationPlayer.play("Hover", -1, 0.67)
	set_map_pos(start_pos)
