extends "res://scripts/item.gd"

export var img: Texture
export var target_weapon: PackedScene

func _ready():
	set_map_pos(start_pos)
	$Sprite.texture = img
